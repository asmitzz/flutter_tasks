import 'package:flutter/material.dart';
import 'package:flutter_tasks/providers/time_provider.dart';
import 'package:flutter_tasks/screens/weather.dart';
import 'package:flutter_tasks/screens/timer.dart';
import 'package:provider/provider.dart';

void main() {
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
            "/": (context) => const TimerScreen(),
            "/weather": (context) => const CurrentWeatherScreen()
          },
        );
      },
    );
  }
}
