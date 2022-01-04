import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
      await dio.download(url, path, onReceiveProgress: (received, total) {
        if (total != -1) {
          progress = (received / total * 100).toStringAsFixed(0) + "%";
        } else {
          progress = (received / (1024 * 1024)).toStringAsFixed(0) + "mb";
        }

        Fluttertoast.showToast(
            msg: "Dowloading $progress",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      });
       Fluttertoast.showToast(
            msg: "Dowload Complete",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
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
      ),
    );
  }
}
