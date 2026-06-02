import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/features/location_tracking/domain/models/location.dart';
import 'package:location_history/features/map/presentation/cubits/map_animation_state.dart';

/// {@template map_animation_cubit}
/// Publishes map camera animation requests from sibling UI components.
/// {@endtemplate}
class MapAnimationCubit extends Cubit<MapAnimationState> {
  /// {@macro map_animation_cubit}
  MapAnimationCubit() : super(const MapAnimationIdle());

  /// Requests the map camera to animate to [location].
  void animateToLocation(Location location) {
    emit(MapLocationAnimationRequested(location: location));
  }
}
