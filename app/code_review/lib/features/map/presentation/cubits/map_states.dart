import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/location_tracking/domain/models/location.model.dart';

abstract class MapState {
  const MapState();
}

class MapInitialState extends MapState {
  const MapInitialState();
}

class MapLocationsLoaded extends MapState {
  const MapLocationsLoaded({required this.locations});

  final List<Location> locations;
}

class MapLocationsError extends MapState {
  const MapLocationsError({required this.failure});

  final Failure failure;
}
