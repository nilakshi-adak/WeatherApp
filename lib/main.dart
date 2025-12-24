import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:weatherapp/constant/constant.dart';
import 'package:weatherapp/geo_location/geolocation.dart';
import 'package:weatherapp/model/current.dart';
import 'package:weatherapp/search/model/position.dart';
import 'package:weatherapp/search/model/search_results.dart';
import 'package:weatherapp/search/pages/search_page.dart';
import 'package:weatherapp/views/card_forecast.dart';
import 'package:weatherapp/views/card_main.dart';
import 'package:weatherapp/views/card_row.dart';
import 'package:weatherapp/views/loading_view.dart';
import 'package:weatherapp/views/network_broken.dart';
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
      title: StringConstant.appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.amber),
      home: MyHomePage(title: StringConstant.appTitle),
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
  var userConsent = '';

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
    _updateData();
  }

  /// Check whether internet is available or not
  Future<bool> _isNetworkAvailable() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi);
  }

  /// Update user consent locally
  Future<void> _setUserPreference(String settings) async {
    final pref = await _prefs;
    pref.setString(StringConstant.userConsent, settings).then((value) => _updateData());
  }

  /// Return three cases - Accepted, Denied, Empty
  Future<String> _getUserPreference() async {
    final pref = await _prefs;
    return pref.getString(StringConstant.userConsent) ?? '';
  }

  Future<Position> _getUsersLocation() async {
    final location = await GeoLocation().getCurrentPosition();
    return location;
  }

  /// Update data based on preference
  Future<void> _updateData() async {
    userConsent = await _getUserPreference();
    switch (userConsent) {
      case '':
        _showUserConsentDialog();
        break;
      case StringConstant.locationAllowed:
        _getWeatherData(await _getUsersLocation());
        setState(() {});
        break;
      case StringConstant.locationDenied:
        _getWeatherData(defaultPositionData());
        setState(() {});
        break;
      default:
    }
  }

  /// Based on users consent it will dismiss the dialog and set pref
  Future<void> _popAndUpdateConsent(BuildContext context, String consent) async {
    Navigator.of(context).pop();
    _setUserPreference(consent);
  }

  /// Asks user consent to get user's location data
  void _showUserConsentDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(StringConstant.userConsentAlertDialogTitle),
          content: Text(StringConstant.userConsentAlertDialogShortDesc),
          actions: [
            TextButton(
              child: Text(StringConstant.allow),
              onPressed: () async => await _popAndUpdateConsent(context, StringConstant.locationAllowed),
            ),
            TextButton(
              child: Text(StringConstant.deny),
              onPressed: () async => await _popAndUpdateConsent(context, StringConstant.locationDenied),
            )
          ],
        );
      },
    );
  }

  /// Get server data based on Position provide
  void _getWeatherData(Position position) {
    showNetworkBroken = false;
    _isNetworkAvailable().then(
      (value) {
        if (value) {
          return widget.currentLocationService.getForecastData(position.latitude, position.longitude).then(
            (value) {
              location = value;
              setState(() {});
            },
          );
        } else {
          showNetworkBroken = true;
          setState(() {});
        }
      },
    );
  }

  /// Search modal appears
  Future<void> _showSearchModal(BuildContext context) async {
    final searchResult = await showModalBottomSheet(
      context: context,
      builder: (context) => const SearchPage(),
      enableDrag: true,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      clipBehavior: Clip.antiAliasWithSaveLayer,
    );
    if (searchResult is SearchResult) {
      if (searchResult.lon != null && searchResult.lat != null) {
        _getWeatherData(defaultPositionData(lon: searchResult.lon!, lat: searchResult.lat!));
      }
    }
  }

  void updateState() async {
    await _updateData();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showNetworkBroken
          ? networkBrokenView(context, updateState)
          : location == null
              ? loadingView(context)
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Column(
                      children: [
                        cardMain(location!, userConsent),
                        cardRow(
                          context,
                          StringConstant.uvIndex,
                          StringConstant.humidity,
                          location!.current?.uv.toString() ?? StringConstant.loading,
                          location!.current?.humidity.toString() ?? StringConstant.loading,
                          StringConstant.uvIcon,
                          StringConstant.humidityIcon,
                          null,
                          StringConstant.percent,
                          false,
                        ),
                        cardRow(
                          context,
                          StringConstant.wind,
                          StringConstant.visibility,
                          location!.current?.windKph.toString() ?? StringConstant.loading,
                          location!.current?.visKm.toString() ?? StringConstant.loading,
                          StringConstant.windIcon,
                          StringConstant.visibilityIcon,
                          StringConstant.kmph,
                          StringConstant.km,
                          false,
                        ),
                        cardRow(
                          context,
                          StringConstant.empty,
                          StringConstant.precipitation,
                          location!.current?.windDegree.toString() ?? StringConstant.loading,
                          location!.current?.precipMm.toString() ?? StringConstant.loading,
                          StringConstant.empty,
                          StringConstant.precipitationIcon,
                          null,
                          StringConstant.mm,
                          true,
                        ),
                        forecast(context, location?.forecast),
                      ],
                    ),
                  ),
                ),
      floatingActionButton: location == null
          ? null
          : FloatingActionButton(
              onPressed: () => _showSearchModal(context),
              child: const Icon(Icons.search),
            ),
    );
  }
}
