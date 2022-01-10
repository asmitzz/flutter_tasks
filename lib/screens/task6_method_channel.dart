import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MethodChannelExample extends StatefulWidget {
  const MethodChannelExample({Key? key}) : super(key: key);

  @override
  _MethodChannelExampleState createState() => _MethodChannelExampleState();
}

class _MethodChannelExampleState extends State<MethodChannelExample> {
  late String username = "No username found";

  static const platform = MethodChannel("username");
  static const timerStream = EventChannel("timer");
  int timer = 0;

  StreamSubscription? timerSubscription;

  Future<void> getUsername() async {
    try {
      String res = await platform.invokeMethod("getUsername");
      setState(() {
        username = res;
      });
    } on PlatformException catch (e) {
      setState(() {
        username = "Failed to get username : ${e.toString()}";
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    void updateTimer(event) {
      timer = event;
      setState(() {});
    }

    void startTimer() {
      timerSubscription = 
          timerStream.receiveBroadcastStream().listen(updateTimer);
    }

    void stopTimer() {
      if (timerSubscription != null) {
        timerSubscription?.cancel();
      }
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(username,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 34)),
              Text(timer.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 34)),
              ElevatedButton(
                child: const Text('Get Username'),
                onPressed: getUsername,
              ),
              ElevatedButton(
                child: const Text('Start timer'),
                onPressed: startTimer,
              ),
              ElevatedButton(
                child: const Text('Stop timer'),
                onPressed: stopTimer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
