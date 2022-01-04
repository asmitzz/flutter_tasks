import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ndialog/ndialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadFile extends StatefulWidget {
  const DownloadFile({Key? key}) : super(key: key);
  @override
  _DownloadFileState createState() => _DownloadFileState();
}

class _DownloadFileState extends State {
  var imageUrl =
      "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4";
  bool downloading = false;
  String downloadingStr = "No data";
  String savePath = "";
  late bool isLoading;
  bool _allowWriteFile = false;
  late String extension = imageUrl.substring(imageUrl.lastIndexOf("/"));

  String progress = "";
  late Dio dio;

  @override
  void initState() {
    super.initState();
    dio = Dio();
  }

  requestWritePermission() async {
    PermissionStatus status = await Permission.storage.request();
    if (await Permission.storage.request().isGranted) {
      setState(() {
        _allowWriteFile = true;
      });
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
    }
  }

  Future<String> getDirectoryPath() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();

    Directory directory = await Directory(appDocDirectory.path + '/' + 'video')
        .create(recursive: true);
    return directory.path;
  }

  Future downloadFile(String url, path) async {
    if (!_allowWriteFile) {
      await requestWritePermission();
    }
    try {
      ProgressDialog progressDialog = ProgressDialog(context,
          message: const Text(""),
          dialogTransitionType: DialogTransitionType.Bubble,
          title: const Text("Downloading File"));

      progressDialog.show();
      await dio.download(url, path, onReceiveProgress: (rec, total) {
        setState(() {
          isLoading = true;
          progress = ((rec / total) * 100).toStringAsFixed(0) + "%";
          progressDialog.setMessage(Text("Dowloading $progress"));
        });
      });
      progressDialog.dismiss();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: const Text("Download File"),
            leading: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ))),
        body: Center(
            child: downloading
                ? SizedBox(
                    height: 250,
                    width: 250,
                    child: Card(
                      color: Colors.pink,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            downloadingStr,
                            style: const TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  )
                : ElevatedButton(
                    onPressed: () async {
                      final path = await getDirectoryPath();
                      downloadFile(imageUrl, "$path/$extension");
                    },
                    child: const Text("Download file"))),
      ),
    );
  }
}
