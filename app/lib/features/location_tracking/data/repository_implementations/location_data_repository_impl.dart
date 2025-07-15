import 'package:location_history/features/location_tracking/data/datasources/location_data_remote_data_source.dart';
import 'package:location_history/features/location_tracking/domain/models/location.model.dart';
import 'package:location_history/features/location_tracking/domain/models/movement_segment.dart';
import 'package:location_history/features/location_tracking/domain/repositories/location_data_repository.dart';

/// {@template location_data_repository_impl}
/// A class that represents location data repository impl.
/// {@endtemplate}
class LocationDataRepositoryImpl extends LocationDataRepository {
/// {@macro location_data_repository_impl}
  const LocationDataRepositoryImpl({required this.locationRemoteDataSource});

  final LocationDataRemoteDataSource locationRemoteDataSource;

  @override
  Future<List<Location>> getLocationsByDate({
    required DateTime start,
    required DateTime end,
  }) {
    return locationRemoteDataSource.getLocationsByDate(start: start, end: end);
  }

  @override
  Future<void> saveLocation({required Location location}) async {
    await locationRemoteDataSource.saveLocation(location: location);
  }

  @override
  Future<void> saveMovementSegment({required MovementSegment movementSegment}) {
    // TODO: implement saveMovementSegment
    throw UnimplementedError();
  }
}
