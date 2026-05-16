import 'package:background_location_2/background_location.dart' as bg;

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

  /// Converts a `background_location_2` update into a domain value.
  ///
  /// The plugin reports timestamp values in milliseconds since epoch; the domain
  /// stores them as [DateTime] values.
  ///
  /// Parameters:
  /// - bgLocation: [bg.Location] to convert
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
