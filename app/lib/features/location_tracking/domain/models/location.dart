import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:location_history/features/location_tracking/domain/models/activity.dart';
import 'package:location_history/features/location_tracking/domain/models/battery.dart';

/* 
  To-Do:
    - [ ] Check if timestamp is parsed correctly
*/

class Location {
  const Location({
    required this.lat,
    required this.long,
    required this.accuracy,
    required this.speed,
    required this.heading,
    required this.altitude,
    required this.timestamp,
    required this.odometer,
    required this.activity,
    required this.battery,
  });

  final double lat;
  final double long;
  final double accuracy;
  final double speed;
  final double heading;
  final double altitude;
  final DateTime timestamp;
  final double odometer;
  final Activity activity;
  final Battery battery;

  static Location fromBGLocation(bg.Location bgLocation) {
    return Location(
      lat: bgLocation.coords.latitude,
      long: bgLocation.coords.longitude,
      timestamp: timestampFromBGLocation(
        timestamp: bgLocation.timestamp,
        age: bgLocation.age,
      ),
      activity: Activity.fromBGActivity(bgLocation.activity),
      accuracy: bgLocation.coords.accuracy,
      speed: bgLocation.coords.speed,
      heading: bgLocation.coords.heading,
      altitude: bgLocation.coords.altitude,
      odometer: bgLocation.odometer,
      battery: Battery.fromBGBattery(battery: bgLocation.battery),
    );
  }

  static DateTime timestampFromBGLocation({
    required String timestamp,
    required int age,
  }) {
    return DateTime.parse(timestamp).subtract(Duration(milliseconds: age));
  }
}
