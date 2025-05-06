import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/location_tracking/domain/models/location.model.dart';
import 'package:location_history/features/location_tracking/domain/usecases/get_location_data.dart';
import 'package:location_history/features/map/presentation/cubits/map_states.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit({required this.getLocationData}) : super(const MapInitialState());

  final GetLocationData getLocationData;

  void loadLocations() async {
    final Either<Failure, List<Location>> locationsEither =
        await getLocationData();

    locationsEither.fold(
      (failure) {},
      (locations) => emit(MapLocationsLoaded(locations: locations)),
    );
  }
}
