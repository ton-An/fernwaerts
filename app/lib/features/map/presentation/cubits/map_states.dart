import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/location_tracking/domain/models/location.model.dart';

abstract class MapState {
  const MapState();
}

/// {@template map_initial_state}
/// A state class that represents mapinitial state.
/// {@endtemplate}
class MapInitialState extends MapState {
/// {@macro map_initial_state}
  const MapInitialState();
}

/// {@template map_locations_loaded}
/// A class that represents map locations loaded.
/// {@endtemplate}
class MapLocationsLoaded extends MapState {
/// {@macro map_locations_loaded}
  const MapLocationsLoaded({required this.locations});

  final List<Location> locations;
}

/// {@template map_locations_error}
/// A class that represents map locations error.
/// {@endtemplate}
class MapLocationsError extends MapState {
/// {@macro map_locations_error}
  const MapLocationsError({required this.failure});

  final Failure failure;
}
