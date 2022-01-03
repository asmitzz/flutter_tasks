import 'dart:async';

import 'package:flutter/material.dart';

class TimeProvider with ChangeNotifier {
  int time = 300;
  bool isStart = false;
  Timer? timeController;
  startTime(context) {
    timeController = Timer.periodic(const Duration(seconds: 1), (timer) {
      isStart = true;

      if (time == 0) {
        timer.cancel();
        showDialog(
            context: context,
            builder: (context) => const AlertDialog(
                  title: Text("Time Up"),
                ));
      } else {
        time--;
        notifyListeners();
      }
    });
  }

  void pauseTime() {
    if (timeController != null) {
      isStart = false;
      timeController!.cancel();
      notifyListeners();
    }
  }

  resetTime() {
    time = 300;
    isStart = false;
    timeController!.cancel();
    notifyListeners();
  }
}
