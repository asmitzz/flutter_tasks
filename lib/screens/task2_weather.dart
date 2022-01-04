import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tasks/models/weather_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrentWeatherScreen extends StatefulWidget {
  const CurrentWeatherScreen({Key? key}) : super(key: key);
  @override
  _CurrentWeatherScreenState createState() => _CurrentWeatherScreenState();
}

class _CurrentWeatherScreenState extends State<CurrentWeatherScreen> {

  String cityName = "jabalpur";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      if (mounted) {
        setState(() {});
        Timer.periodic(const Duration(seconds: 5), (timer) async {
          await getCurrentWeather(cityName);
          if (mounted) {
            setState(() {});
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder(
                builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    Weather _weather = snapshot.data;
                    return weatherBox(_weather);
                  } else if (snapshot.hasError) {
                    return const Text("Error getting weather");
                  } else {
                    return const Text("No results found");
                  }
                },
                future: getCurrentWeather(cityName),
              ),
            ],
          ),
        ));
  }
}

Widget weatherBox(Weather _weather) {
  return Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
    Container(
        margin: const EdgeInsets.all(10.0),
        child: Text(
          _weather.cityName,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 55),
        )),
    Container(
        margin: const EdgeInsets.all(10.0),
        child: Text(
          "${_weather.temp}°C",
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 55),
        )),
    Container(
        margin: const EdgeInsets.all(5.0), child: Text(_weather.description)),
    Container(
        margin: const EdgeInsets.all(5.0),
        child: Text("Feels:${_weather.feelsLike}°C")),
    Container(
        margin: const EdgeInsets.all(5.0),
        child: Text("H:${_weather.high}°C L:${_weather.low}°C")),
  ]);
}

Future getCurrentWeather(String cityName) async {
  late Weather weather;
  String apiKey = "17cc0ba49361a4a0fe7db3bbe77e1ba9";

  String url =
      "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric";

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      weather = Weather.fromJson(jsonDecode(response.body));
    }
    return weather;
  } catch (e) {
    rethrow;
  }
}
