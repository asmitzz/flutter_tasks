import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadFile extends StatefulWidget {
  const DownloadFile({Key? key}) : super(key: key);

  @override
  _DownloadFileState createState() => _DownloadFileState();
}

class _DownloadFileState extends State<DownloadFile> {
  int progress = 0;

  final ReceivePort _receivePort = ReceivePort();

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort? sendPort = IsolateNameServer.lookupPortByName("downloading");

    ///ssending the data
    if (sendPort != null) {
      sendPort.send([id, status, progress]);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ///register a send port for the other isolates
    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, "downloading");

    ///Listening for the data is comming other isolataes
    _receivePort.listen((message) {
      setState(() {
        progress = message[2];
      });

      print(progress);
    });

    FlutterDownloader.registerCallback(downloadingCallback);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Download file"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "$progress",
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(
              height: 60,
            ),
            TextButton(
              child: const Text("Start Downloading"),
              onPressed: () async {
                try {
                  final status = await Permission.storage.request();

                  Future<Directory> getDirectoryPath() async {
                    Directory appDocDirectory =
                        await getApplicationDocumentsDirectory();

                    Directory directory =
                        await Directory(appDocDirectory.path + '/' + 'video')
                            .create(recursive: true);
                    return directory;
                  }

                  if (status.isGranted) {
                    Directory? externalDir;
                    if (Platform.isIOS) {
                      externalDir = await getDirectoryPath();
                    } else {
                      externalDir = await getExternalStorageDirectory();
                    }

                    final id = await FlutterDownloader.enqueue(
                      url:
                          "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4",
                      savedDir: externalDir == null ? "" : externalDir.path,
                      fileName: "demo",
                      showNotification: true,
                      openFileFromNotification: true,
                    );
                    print(id);
                  } else {
                    print("Permission deined");
                  }
                } catch (e) {
                  print(e.toString());
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
