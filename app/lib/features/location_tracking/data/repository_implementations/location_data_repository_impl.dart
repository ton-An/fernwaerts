import 'package:fpdart/fpdart.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';
import 'package:location_history/core/failures/storage/storage_write_failure.dart';
import 'package:location_history/features/location_tracking/data/datasources/location_data_remote_data_source.dart';
import 'package:location_history/features/location_tracking/domain/models/activity_segment.dart';
import 'package:location_history/features/location_tracking/domain/models/location.dart';
import 'package:location_history/features/location_tracking/domain/repositories/location_data_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  Future<Either<Failure, None>> saveLocation({
    required Location location,
  }) async {
    try {
      await locationRemoteDataSource.saveLocation(location: location);

      return const Right(None());
    } on PostgrestException {
      return const Left(StorageWriteFailure());
    }
  }

  @override
  Future<Either<Failure, None>> saveActivitySegment({
    required ActivitySegment activitySegment,
  }) async {
    try {
      await locationRemoteDataSource.saveActivitySegment(
        activitySegment: activitySegment,
      );

      return const Right(None());
    } on PostgrestException {
      return const Left(StorageWriteFailure());
    }
  }
}
