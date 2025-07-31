import 'package:background_location_2/background_location.dart' as bg;

/* 
  To-Do:
    - [ ] Check if timestamp is parsed correctly
*/

class RecordedLocation {
  RecordedLocation({
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.coordinatesAccuracy,
    required this.speed,
    required this.speedAccuracy,
    required this.heading,
    required this.headingAccuracy,
    required this.ellipsoidalAltitude,
    required this.altitudeAccuracy,
  });

  final DateTime timestamp;

  final num latitude;
  final num longitude;
  final num coordinatesAccuracy;

  final num speed;
  final num speedAccuracy;

  final num heading;
  final num headingAccuracy;

  final num ellipsoidalAltitude;
  final num altitudeAccuracy;

  static RecordedLocation fromBGLocation({required bg.Location bgLocation}) {
    return RecordedLocation(
      timestamp: DateTime.fromMicrosecondsSinceEpoch(
        bgLocation.time.floor() * 1000,
      ),
      latitude: bgLocation.latitude,
      longitude: bgLocation.longitude,
      coordinatesAccuracy: bgLocation.accuracy,
      speed: bgLocation.speed,
      speedAccuracy: bgLocation.speedAccuracy,
      heading: bgLocation.bearing,
      headingAccuracy: bgLocation.bearingAccuracy,
      ellipsoidalAltitude: bgLocation.ellipsoidalAltitude,
      altitudeAccuracy: bgLocation.altitudeAccuracy,
    );
  }
}
