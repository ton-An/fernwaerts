import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/location_tracking/domain/models/location.model.dart';
import 'package:location_history/features/location_tracking/domain/usecases/get_locations_by_date.dart';
import 'package:location_history/features/map/presentation/cubits/map_states.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit({required this.getLocationData}) : super(const MapInitialState());

  final GetLocationsByDate getLocationData;

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
