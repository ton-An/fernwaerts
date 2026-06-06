import 'package:tracelet/tracelet.dart' as tracelet;

/// Activity classification reported for a recorded location.
///
/// Values mirror the activity strings currently handled from the background
/// location plugin. Unknown or unsupported plugin values map to [unknown].
enum ActivityType {
  /// The device is not moving.
  still,

  /// The user is walking.
  walking,

  /// The user is on foot without a more specific classification.
  onFoot,

  /// The user is running.
  running,

  /// The user is traveling by bicycle.
  onBicycle,

  /// The user is traveling in a vehicle.
  inVehicle,

  /// The activity value is missing or not recognized.
  unknown;

  /// Creates an [ActivityType] from a storage/plugin activity string.
  ///
  /// Parameters:
  /// - value: [String] storage/plugin activity value to convert
  ///
  /// Returns:
  /// - [ActivityType] matching [value], or [ActivityType.unknown] when the
  ///   value is unsupported
  static ActivityType fromString(String value) {
    switch (value) {
      case 'still':
        return ActivityType.still;
      case 'walking':
        return ActivityType.walking;
      case 'on_foot':
        return ActivityType.onFoot;
      case 'running':
        return ActivityType.running;
      case 'on_bicycle':
        return ActivityType.onBicycle;
      case 'in_vehicle':
        return ActivityType.inVehicle;
      default:
        return ActivityType.unknown;
    }
  }

  /// Returns the storage/plugin string for this activity type.
  @override
  String toString() {
    switch (this) {
      case ActivityType.still:
        return 'still';
      case ActivityType.walking:
        return 'walking';
      case ActivityType.onFoot:
        return 'on_foot';
      case ActivityType.running:
        return 'running';
      case ActivityType.onBicycle:
        return 'on_bicycle';
      case ActivityType.inVehicle:
        return 'in_vehicle';
      case ActivityType.unknown:
        return 'unknown';
    }
  }

  static ActivityType fromTraceletType(
    tracelet.ActivityType traceletActivityType,
  ) {
    switch (traceletActivityType) {
      case tracelet.ActivityType.still:
        return ActivityType.still;
      case tracelet.ActivityType.walking:
        return ActivityType.walking;
      case tracelet.ActivityType.running:
        return ActivityType.running;
      case tracelet.ActivityType.onFoot:
        return ActivityType.onFoot;
      case tracelet.ActivityType.inVehicle:
        return ActivityType.inVehicle;
      case tracelet.ActivityType.onBicycle:
        return ActivityType.onBicycle;
      case tracelet.ActivityType.unknown:
        return ActivityType.unknown;
    }
  }
}
