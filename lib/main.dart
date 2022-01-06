import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_tasks/providers/time_provider.dart';
import 'package:flutter_tasks/screens/task2_weather.dart';
import 'package:flutter_tasks/screens/task1_timer.dart';
import 'package:flutter_tasks/screens/task3_download_file.dart';
import 'package:flutter_tasks/screens/task4_custom_paint.dart';
import 'package:flutter_tasks/vori_logo/vori_custom_paint.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TimeProvider>(
          create: (_) => TimeProvider(),
        ),
      ],
      builder: (context, child) {
        return MaterialApp(
          title: "Flutter Tasks",
          initialRoute: "/",
          routes: {
            "/": (context) => const VoriLogo(),
            "/timer": (context) => const TimerScreen(),
            "/painter": (context) => const MyPainter(),
            "/download": (context) => const DownloadFile(),
            "/weather": (context) => const CurrentWeatherScreen(),
          },
        );
      },
    );
  }
}
