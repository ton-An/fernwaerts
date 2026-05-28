import 'package:location_history/features/location_tracking/domain/models/location.dart';

/// {@template map_animation_state}
/// Base state for map camera animation requests.
/// {@endtemplate}
abstract class MapAnimationState {
  /// {@macro map_animation_state}
  const MapAnimationState();
}

/// {@template map_animation_idle}
/// No map camera animation has been requested.
/// {@endtemplate}
class MapAnimationIdle extends MapAnimationState {
  /// {@macro map_animation_idle}
  const MapAnimationIdle();
}

/// {@template map_location_animation_requested}
/// Requests the map camera to animate to [location].
/// {@endtemplate}
class MapLocationAnimationRequested extends MapAnimationState {
  /// {@macro map_location_animation_requested}
  const MapLocationAnimationRequested({required this.location});

  final Location location;
}
