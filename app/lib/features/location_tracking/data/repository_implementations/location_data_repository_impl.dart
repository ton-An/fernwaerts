import 'package:location_history/features/location_tracking/data/datasources/location_data_remote_data_source.dart';
import 'package:location_history/features/location_tracking/domain/models/activity_segment.dart';
import 'package:location_history/features/location_tracking/domain/models/location.dart';
import 'package:location_history/features/location_tracking/domain/repositories/location_data_repository.dart';

/*
  To-Do:
    - [ ] add failures to methods
*/

/// {@template location_data_repository_impl}
/// Data-layer implementation of [LocationDataRepository].
///
/// This repository delegates persisted location reads and writes to
/// [LocationDataRemoteDataSource].
/// {@endtemplate}
class LocationDataRepositoryImpl extends LocationDataRepository {
  /// {@macro location_data_repository_impl}
  const LocationDataRepositoryImpl({required this.locationRemoteDataSource});

  final LocationDataRemoteDataSource locationRemoteDataSource;

  @override
  Future<Stream<List<Location>>> getLocationsByDate({
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
  Future<void> saveActivitySegment({
    required ActivitySegment activitySegment,
  }) async {
    await locationRemoteDataSource.saveActivitySegment(
      activitySegment: activitySegment,
    );
  }
}
