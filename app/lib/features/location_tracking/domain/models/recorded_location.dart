import 'package:location_history/features/location_tracking/domain/enums/activity_type.dart';
import 'package:tracelet/tracelet.dart' as tracelet;

/// {@template recorded_location}
/// Raw location update emitted by the platform tracking plugin.
///
/// [RecordedLocation] keeps plugin-shaped data out of the rest of the domain
/// layer. Use [Location.fromRecordedLocation] when a raw update is ready to be
/// associated with a user, device, and persistence metadata.
/// {@endtemplate}
class RecordedLocation {
  /// {@macro recorded_location}
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

  final double latitude;
  final double longitude;
  final double coordinatesAccuracy;

  final double speed;
  final double speedAccuracy;

  final double heading;
  final double headingAccuracy;

  final double ellipsoidalAltitude;
  final double altitudeAccuracy;

  final ActivityType activityType;
  final double activityConfidence;

  final double batteryLevel;
  final bool isDeviceCharging;

  /// Converts a `background_location_2` update into a domain value.
  ///
  /// The plugin reports timestamp values in milliseconds since epoch; the domain
  /// stores them as [DateTime] values.
  ///
  /// Parameters:
  /// - bgLocation: [bg.Location] to convert
  static RecordedLocation fromTraceletLocation({
    required tracelet.Location traceletLocation,
  }) {
    return RecordedLocation(
      timestamp: DateTime.parse(traceletLocation.timestamp),
      latitude: traceletLocation.coords.latitude,
      longitude: traceletLocation.coords.longitude,
      coordinatesAccuracy: traceletLocation.coords.accuracy,
      speed: traceletLocation.coords.speed,
      speedAccuracy: traceletLocation.coords.speedAccuracy,
      heading: traceletLocation.coords.heading,
      headingAccuracy: traceletLocation.coords.headingAccuracy,
      ellipsoidalAltitude: traceletLocation.coords.altitude,
      altitudeAccuracy: traceletLocation.coords.altitudeAccuracy,
      activityType: ActivityType.fromTraceletType(
        traceletLocation.activity.type,
      ),
      activityConfidence: _confidenceFromTraclet(
        traceletLocation.activity.confidence,
      ),
      batteryLevel: traceletLocation.battery.level,
      isDeviceCharging: traceletLocation.battery.isCharging,
    );
  }

  static double _confidenceFromTraclet(tracelet.ActivityConfidence confidence) {
    switch (confidence) {
      case tracelet.ActivityConfidence.high:
        return 0.9;
      case tracelet.ActivityConfidence.medium:
        return 0.65;
      case tracelet.ActivityConfidence.low:
        return 0.25;
    }
  }
}
