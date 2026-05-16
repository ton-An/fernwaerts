import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/location_tracking/domain/models/location.dart';
import 'package:location_history/features/location_tracking/domain/usecases/get_locations_by_date.dart';
import 'package:location_history/features/map/presentation/cubits/map_state.dart';

/*
  To-Do:
    - [ ] Add tests
*/

/// {@template map_cubit}
/// Coordinates map presentation state for the active calendar selection.
///
/// The Cubit subscribes to the location stream for the selected date range and
/// replaces the previous subscription whenever the range changes.
/// {@endtemplate}
class MapCubit extends Cubit<MapState> {
  /// {@macro map_cubit}
  MapCubit({required this.getLocationData}) : super(const MapInitialState());

  final GetLocationsByDate getLocationData;

  StreamSubscription? locationsStreamSubscription;

  /// Loads the locations whose timestamps fall within [start] and [end].
  ///
  /// Parameters:
  /// - start: [DateTime] inclusive lower bound for the selected range.
  /// - end: [DateTime] inclusive upper bound for the selected range.
  ///
  /// Emits:
  /// - [MapLocationsLoaded] each time the location stream returns data.
  /// - [MapLocationsError] when the location stream reports a [Failure].
  void loadLocationsByDate({
    required DateTime start,
    required DateTime end,
  }) async {
    locationsStreamSubscription?.cancel();

    final Stream<Either<Failure, List<Location>>> locationsEitherStream =
        getLocationData(start: start, end: end);

    locationsStreamSubscription = locationsEitherStream.listen((
      Either<Failure, List<Location>> locationsEither,
    ) {
      locationsEither.fold(
        (Failure failure) => emit(MapLocationsError(failure: failure)),
        (List<Location> locations) {
          emit(MapLocationsLoaded(locations: locations));
        },
      );
    });
  }
}
