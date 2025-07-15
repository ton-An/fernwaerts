import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:location_history/features/location_tracking/domain/enums/activity_type.dart';

/* 
  To-Do:
    - [ ] Check if timestamp is parsed correctly
*/

/// {@template recorded_location}
/// {@macro recorded_location}
/// A class that represents RecordedLocation.
/// {@endtemplate}
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
    required this.activityType,
    required this.activityConfidence,
    required this.batteryLevel,
    required this.isDeviceCharging,
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

  final ActivityType activityType;
  final num activityConfidence;

  final num batteryLevel;
  final bool isDeviceCharging;

  static RecordedLocation fromBGLocation(bg.Location bgLocation) {
    return RecordedLocation(
      timestamp: timestampFromBGLocation(
        timestamp: bgLocation.timestamp,
        age: bgLocation.age,
      ),
      latitude: bgLocation.coords.latitude,
      longitude: bgLocation.coords.longitude,
      coordinatesAccuracy: bgLocation.coords.accuracy,
      speed: bgLocation.coords.speed,
      speedAccuracy: bgLocation.coords.speedAccuracy,
      heading: bgLocation.coords.heading,
      headingAccuracy: bgLocation.coords.headingAccuracy,
      ellipsoidalAltitude: bgLocation.coords.altitude,
      altitudeAccuracy: bgLocation.coords.altitudeAccuracy,
      activityType: ActivityType.fromBGActivityType(
        bgActivityType: bgLocation.activity.type,
      ),
      activityConfidence: bgLocation.activity.confidence.toDouble(),
      batteryLevel: bgLocation.battery.level,
      isDeviceCharging: bgLocation.battery.isCharging,
    );
  }

  static DateTime timestampFromBGLocation({
    required String timestamp,
    required int age,
  }) {
    return DateTime.parse(timestamp).subtract(Duration(milliseconds: age));
  }
}
