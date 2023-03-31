import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/current.dart';
import 'package:flutter_application_1/views/card_forecast.dart';
import 'package:flutter_application_1/views/card_main.dart';
import 'package:flutter_application_1/views/card_row.dart';

import 'service/current_location_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeatherApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.amber),
      home: MyHomePage(title: 'WeatherApp'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;
  final currentlocationservice = CurrentLocationService();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

CurrentLocation? location;

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    widget.currentlocationservice.getForecastData().then((value) {
      location = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: location == null
          ? Container()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Column(
                  children: [
                    cardMain(location!),
                    cardRow(
                      context,
                      'UV Index',
                      'Humidity',
                      location!.current?.uv.toString() ?? 'loading..',
                      location!.current?.humidity.toString() ?? 'loading..',
                      'uv.png',
                      'humidity.png',
                      null,
                      '%',
                      false,
                    ),
                    cardRow(
                      context,
                      'Wind',
                      'Visibility',
                      location!.current?.windKph.toString() ?? 'loading..',
                      location!.current?.visKm.toString() ?? 'loading..',
                      'wind.png',
                      'visibility.png',
                      'kmph',
                      'km',
                      false,
                    ),
                    cardRow(
                      context,
                      '',
                      'Precipitation',
                      location!.current?.windDegree.toString() ?? 'loading..',
                      location!.current?.precipMm.toString() ?? 'loading..',
                      '',
                      'precipitation.png',
                      null,
                      'mm',
                      true,
                    ),
                    forecast(context, location?.forecast),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.search)),
    );
  }
}
