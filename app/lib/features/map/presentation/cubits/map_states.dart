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
