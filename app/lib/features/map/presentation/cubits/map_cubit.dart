import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/location_tracking/domain/models/location.dart';
import 'package:location_history/features/location_tracking/domain/usecases/get_locations_by_date.dart';
import 'package:location_history/features/map/presentation/cubits/map_states.dart';
import 'package:location_history/features/map/presentation/pages/map_page/map_page.dart';

/*
  To-Do:
    - [ ] Add tests
*/

/// {@template map_cubit}
/// Manages the state of the [MapPage]:
/// - Loads and displays location data based on a date range.
/// {@endtemplate}
class MapCubit extends Cubit<MapState> {
  /// {@macro map_cubit}
  MapCubit({required this.getLocationData}) : super(const MapInitialState());

  final GetLocationsByDate getLocationData;

  /// Loads locations based on the provided date range.
  ///
  /// Parameters:
  /// - [start]: The start date of the range.
  /// - [end]: The end date of the range.
  ///
  /// Emits:
  /// - [MapLocationsLoaded] with the loaded locations
  /// - [MapLocationsError] with the failure if loading fails
  void loadLocationsByDate({
    required DateTime start,
    required DateTime end,
  }) async {
    final Either<Failure, List<Location>> locationsEither =
        await getLocationData(start: start, end: end);

    locationsEither.fold(
      (failure) => emit(MapLocationsError(failure: failure)),
      (locations) => emit(MapLocationsLoaded(locations: locations)),
    );
  }
}
