import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/location_tracking/domain/models/location.dart';

/// {@template map_state}
/// Base state for the map presentation layer.
/// {@endtemplate}
abstract class MapState {
  /// {@macro map_state}
  const MapState();
}

/// {@template map_initial_state}
/// State before a location range has emitted data or an error.
/// {@endtemplate}
class MapInitialState extends MapState {
  /// {@macro map_initial_state}
  const MapInitialState();
}

/// {@template map_locations_loaded}
/// State containing the locations for the active calendar selection.
/// {@endtemplate}
class MapLocationsLoaded extends MapState {
  /// {@macro map_locations_loaded}
  const MapLocationsLoaded({required this.locations});

  final List<Location> locations;
}

/// {@template map_locations_error}
/// State emitted when loading the active location range fails.
/// {@endtemplate}
class MapLocationsError extends MapState {
  /// {@macro map_locations_error}
  const MapLocationsError({required this.failure});

  final Failure failure;
}
