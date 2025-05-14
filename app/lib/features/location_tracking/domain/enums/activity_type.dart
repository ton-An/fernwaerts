/*
  To-Do:
    - [ ] Add all possible activity types
*/

enum ActivityType {
  still,
  walking,
  onFoot,
  running,
  onBicycle,
  inVehicle,
  unknown;

  static ActivityType fromBGActivityType({required String bgActivityType}) {
    switch (bgActivityType) {
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
}
