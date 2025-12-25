import 'dart:math' as math;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constant/constant.dart';
import 'model/current.dart';
import 'search/model/position.dart';
import 'search/model/search_results.dart';
import 'search/pages/search_page.dart';
import 'service/current_location_service.dart';
import 'theme/app_theme.dart';
import 'views/card_forecast.dart';
import 'views/card_main.dart';
import 'views/card_row.dart';
import 'views/loading_view.dart';
import 'views/network_broken.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeatherApp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      home: const MyHomePage(
        title: 'WeatherApp',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  final WeatherService _weatherService = WeatherService();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  CurrentLocation? _location;
  bool _showNetworkBroken = false;
  String _userConsent = '';
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await _checkConnectivity();
      await _updateData();
    } catch (e) {
      if (mounted) {
        setState(() {
          _showNetworkBroken = true;
        });
      }
    }
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (!mounted) return;
    setState(() {
      _showNetworkBroken = connectivityResult.any((result) => result == ConnectivityResult.none);
    });
  }

  // Connectivity Management
  Future<bool> _isNetworkAvailable() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult.any((result) => result != ConnectivityResult.none);
  }

  // User Preference Management
  Future<void> _setUserPreference(String settings) async {
    final pref = await _prefs;
    await pref.setString(StringConstant.userConsent, settings);
    await _updateData();
  }

  /// Return three cases - Accepted, Denied, Empty
  Future<String> _getUserPreference() async {
    final pref = await _prefs;
    return pref.getString(StringConstant.userConsent) ?? '';
  }

  Future<Position> _getUsersLocation() async {
    try {
      // Check current permission status
      LocationPermission permission = await Geolocator.checkPermission();

      // If permission is permanently denied, use default location
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permission denied forever');
      }

      // If permission is not granted, request it
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        // If still denied after requesting, use default location
        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
          throw Exception('Location permission denied');
        }
      }

      // Permission is now granted, get actual device location
      final location = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          timeLimit: Duration(seconds: 10),
        ),
      );

      return Position(
        latitude: location.latitude,
        longitude: location.longitude,
        timestamp: location.timestamp,
        accuracy: location.accuracy,
        altitude: location.altitude,
        altitudeAccuracy: location.altitudeAccuracy,
        heading: location.heading,
        headingAccuracy: location.headingAccuracy,
        speed: location.speed,
        speedAccuracy: location.speedAccuracy,
      );
    } catch (e) {
      // Only use default location if permission is denied or error occurs
      return defaultPositionData();
    }
  }

  // Data Management
  Future<void> _updateData() async {
    _userConsent = await _getUserPreference();
    switch (_userConsent) {
      case '':
        if (mounted) {
          _showUserConsentDialog();
        }
        break;
      case StringConstant.locationAllowed:
        await _getWeatherData(await _getUsersLocation());
        break;
      case StringConstant.locationDenied:
        await _getWeatherData(defaultPositionData());
        break;
      default:
    }
    if (mounted) setState(() {});
  }

  // Dialog Management
  Future<void> _popAndUpdateConsent(BuildContext context, String consent) async {
    if (mounted) Navigator.of(context).pop();
    await _setUserPreference(consent);
  }

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

  // Weather Data Management
  Future<void> _getWeatherData(Position position) async {
    if (!mounted) return;
    setState(() {
      _showNetworkBroken = false;
    });

    final isConnected = await _isNetworkAvailable();
    if (!isConnected) {
      if (!mounted) return;
      setState(() {
        _showNetworkBroken = true;
      });
      return;
    }

    try {
      final weatherData = await _weatherService
          .getForecastData(
        position.latitude,
        position.longitude,
      )
          .timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Weather API timeout');
        },
      );
      if (!mounted) return;
      setState(() {
        _location = weatherData;
        _showNetworkBroken = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _showNetworkBroken = true;
        _location = null;
      });
    }
  }

  // UI Actions
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

  Future<void> updateState() async {
    await _updateData();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final subtitle = _location == null
        ? 'Track any city in real-time'
        : (_location?.location?.region?.isNotEmpty ?? false)
            ? _location!.location!.region!
            : (_location?.location?.country ?? '');
    final isRefreshing = _location == null && !_showNetworkBroken;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, _) {
          final gradient = _buildBackgroundGradient(false);
          return Container(
            decoration: BoxDecoration(gradient: gradient),
            child: SafeArea(
              child: Column(
                children: [
                  _buildModernHeader(context, subtitle, isRefreshing),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInOutCubic,
                      child: _buildContentByState(context),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 320),
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: animation,
          child: child,
        ),
        child: _location == null
            ? const SizedBox.shrink()
            : Hero(
                tag: 'search-hero',
                child: Material(
                  key: const ValueKey('search-fab'),
                  elevation: 4,
                  borderRadius: BorderRadius.circular(16),
                  color: theme.colorScheme.primaryContainer,
                  child: InkWell(
                    onTap: () => _showSearchModal(context),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_rounded,
                            size: 22,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Search',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildModernHeader(BuildContext context, String subtitle, bool isRefreshing) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                          letterSpacing: -0.8,
                          color: theme.textTheme.displayLarge?.color,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (_showNetworkBroken) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange.shade600.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.cloud_off_rounded, size: 14, color: Colors.orange.shade600),
                            const SizedBox(width: 4),
                            Text(
                              'Offline',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                if (subtitle.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.65),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentByState(BuildContext context) {
    if (_showNetworkBroken) {
      return KeyedSubtree(
        key: const ValueKey('network'),
        child: networkBrokenView(context, updateState),
      );
    }

    if (_location == null) {
      return KeyedSubtree(
        key: const ValueKey('loading'),
        child: loadingView(context),
      );
    }

    return KeyedSubtree(
      key: const ValueKey('content'),
      child: _buildWeatherScroll(context),
    );
  }

  Widget _buildWeatherScroll(BuildContext context) {
    final currentLocation = _location!;
    return RefreshIndicator(
      onRefresh: updateState,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  cardMain(currentLocation, _userConsent),
                  const SizedBox(height: 16),
                  cardRow(
                    context,
                    StringConstant.uvIndex,
                    StringConstant.humidity,
                    currentLocation.current?.uv.toString() ?? StringConstant.loading,
                    currentLocation.current?.humidity.toString() ?? StringConstant.loading,
                    StringConstant.uvIcon,
                    StringConstant.humidityIcon,
                    null,
                    StringConstant.percent,
                    false,
                    rowIndex: 0,
                  ),
                  const SizedBox(height: 14),
                  cardRow(
                    context,
                    StringConstant.wind,
                    StringConstant.visibility,
                    currentLocation.current?.windKph.toString() ?? StringConstant.loading,
                    currentLocation.current?.visKm.toString() ?? StringConstant.loading,
                    StringConstant.windIcon,
                    StringConstant.visibilityIcon,
                    StringConstant.kmph,
                    StringConstant.km,
                    false,
                    rowIndex: 1,
                  ),
                  const SizedBox(height: 14),
                  cardRow(
                    context,
                    StringConstant.empty,
                    StringConstant.precipitation,
                    currentLocation.current?.windDegree.toString() ?? StringConstant.loading,
                    currentLocation.current?.precipMm.toString() ?? StringConstant.loading,
                    StringConstant.empty,
                    StringConstant.precipitationIcon,
                    null,
                    StringConstant.mm,
                    true,
                    rowIndex: 2,
                  ),
                  const SizedBox(height: 18),
                  forecast(context, currentLocation.forecast),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _buildBackgroundGradient(bool isDark) {
    final palette = _backgroundPalette();
    final oscillation = (math.sin(_pulseController.value * math.pi * 2) + 1) / 2;
    final start = Color.lerp(palette[0], palette[1], oscillation) ?? palette[0];
    final end = Color.lerp(palette[1], palette[2], 1 - oscillation) ?? palette[2];
    return LinearGradient(
      colors: [start, end],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  List<Color> _backgroundPalette() {
    final dynamic isDayFlag = _location?.current?.isDay;
    final isDay = isDayFlag == 1 || isDayFlag == '1';
    if (isDay) {
      return const [Color(0xFFF4F7FF), Color(0xFFE0EAFF), Color(0xFFF9FBFF)];
    }
    return const [Color(0xFFF4F7FF), Color(0xFFE8F0FF), Color(0xFFF9FBFF)];
  }
}
