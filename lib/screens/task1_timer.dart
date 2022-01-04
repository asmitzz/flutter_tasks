import 'package:flutter/material.dart';
import 'package:flutter_tasks/providers/time_provider.dart';
import 'package:provider/provider.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> with WidgetsBindingObserver {
  int time = 300;
  late TimeProvider timeProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      timeProvider.startTime(context);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      timeProvider.pauseTime();
    } else if (state == AppLifecycleState.resumed) {
      timeProvider.startTime(context);
    }
  }

  String formatTime() {
    int totalSeconds = timeProvider.time;
    int hour = totalSeconds ~/ (60 * 60);
    int min = (totalSeconds - (hour * 60 * 60)) ~/ 60;
    int sec = (totalSeconds - (hour * 60 * 60) - (min * 60));

    return "${hour.toString().length == 1 ? "0$hour" : hour} : ${min.toString().length == 1 ? "0$min" : min} : ${sec.toString().length == 1 ? "0$sec" : sec}";
  }

  @override
  Widget build(BuildContext context) {
    timeProvider = Provider.of<TimeProvider>(context);

    return SafeArea(
        child: Scaffold(
      backgroundColor: timeProvider.time < 60 ? Colors.red : Colors.white,
      appBar: AppBar(
        actions: [
          ElevatedButton(
              onPressed: () async {
                if (timeProvider.time != 0) {
                  timeProvider.pauseTime();
                }
                await Navigator.pushNamed(context, "/weather");
              },
              child: const Text("Task2")),
          ElevatedButton(
              onPressed: () async {
                await Navigator.pushNamed(context, "/download");
              },
              child: const Text("Task3"))
        ],
      ),
      body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                formatTime(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 36.0),
              ),
              ElevatedButton(
                  onPressed: timeProvider.isStart
                      ? timeProvider.pauseTime
                      : () => timeProvider.startTime(context),
                  child: timeProvider.isStart
                      ? const Text("Pause")
                      : const Text("Resume")),
              ElevatedButton(
                  onPressed: timeProvider.resetTime,
                  child: const Text("Reset")),
            ],
          )),
    ));
  }
}
