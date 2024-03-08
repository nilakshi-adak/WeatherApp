import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/constant.dart';
import 'package:flutter_application_1/geo_location/geolocation.dart';
import 'package:flutter_application_1/model/current.dart';
import 'package:flutter_application_1/search/model/search_results.dart';
import 'package:flutter_application_1/search/pages/search_page.dart';
import 'package:flutter_application_1/views/card_forecast.dart';
import 'package:flutter_application_1/views/card_main.dart';
import 'package:flutter_application_1/views/card_row.dart';
import 'package:flutter_application_1/views/loading_view.dart';
import 'package:flutter_application_1/views/network_broken.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'service/current_location_service.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
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
  final currentLocationService = WeatherService();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

CurrentLocation? location;

class _MyHomePageState extends State<MyHomePage> {
  bool showNetworkBroken = false;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
    _updateData();
  }

  void _updateData() {
    Connectivity().checkConnectivity().then((connectivityResult) async {
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        showNetworkBroken = false;
        _prefs.then((value) {
          if (value.getBool(Constant.userConsent) ?? false) {
            GeoLocation().getCurrentPosition().then((value) {
              if (value is String) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(value),
                  duration: const Duration(seconds: 8),
                ));
              } else if (value is Position) {
                _prefs
                    .then((value) => value.setBool(Constant.userConsent, true));
                _getLocalWeatherInfo(value);
              }
            });
          } else {
            _showUserConsentDialog(context);
          }
        });
      } else {
        showNetworkBroken = true;
        setState(() {});
      }
    });
  }

  void _showUserConsentDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(Constant.userConsentAlertDialogTitle),
          content: Text(Constant.userConsentAlertDialogShortDesc),
          actions: [
            TextButton(
              child: Text(Constant.allow),
              onPressed: () {
                Navigator.of(context).pop();
                GeoLocation().getCurrentPosition().then((value) {
                  if (value is String) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(value)));
                  } else if (value is Position) {
                    _prefs.then(
                        (value) => value.setBool(Constant.userConsent, true));
                    _getLocalWeatherInfo(value);
                  }
                });
              },
            ),
            TextButton(
              child: Text(Constant.deny),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(Constant.userConsentMessage),
                  action: SnackBarAction(
                      label: 'Sure', onPressed: () => _updateData()),
                ));
              },
            )
          ],
        );
      },
    );
  }

  void _getLocalWeatherInfo(Position value) {
    widget.currentLocationService
        .getForecastData(value.latitude, value.longitude)
        .then((value) {
      location = value;
      showNetworkBroken = false;
      setState(() {});
    });
  }

  Future<void> _showSearchView(BuildContext context) async {
    final searchResult = await showModalBottomSheet(
      context: context,
      builder: (context) => const SearchPage(),
      enableDrag: true,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
    );
    if (searchResult is SearchResult) {
      widget.currentLocationService
          .getForecastData(
              searchResult.lat ?? 22.5726, searchResult.lon ?? 88.3639)
          .then((value) {
        location = value;
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showNetworkBroken
          ? networkBrokenView(context)
          : location == null
              ? loadingView(context)
              : Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/wallpaperskyy.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: SingleChildScrollView(
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
                            location!.current?.humidity.toString() ??
                                'loading..',
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
                            location!.current?.windKph.toString() ??
                                'loading..',
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
                            location!.current?.windDegree.toString() ??
                                'loading..',
                            location!.current?.precipMm.toString() ??
                                'loading..',
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
                ),
      floatingActionButton: location == null
          ? null
          : FloatingActionButton(
              onPressed: () => _showSearchView(context),
              child: const Icon(Icons.search),
            ),
    );
  }
}
