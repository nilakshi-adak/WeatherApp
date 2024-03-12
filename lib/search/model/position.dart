import 'package:geolocator/geolocator.dart';

Position defaultPositionData({double lon = 77.1025, double lat = 28.7041}) {
  return Position(
    longitude: lon,
    latitude: lat,
    timestamp: DateTime.now(),
    accuracy: 0.0,
    altitude: 0,
    altitudeAccuracy: 0,
    heading: 0,
    headingAccuracy: 0,
    speed: 0,
    speedAccuracy: 0,
  );
}
