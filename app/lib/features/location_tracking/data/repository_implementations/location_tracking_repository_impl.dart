import 'package:fpdart/src/either.dart';
import 'package:fpdart/src/option.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/location_tracking/data/datasources/ios_location_tracking_local_data_source.dart';
import 'package:location_history/features/location_tracking/domain/models/activity.dart';
import 'package:location_history/features/location_tracking/domain/models/location.dart';
import 'package:location_history/features/location_tracking/domain/models/movement_segment.dart';
import 'package:location_history/features/location_tracking/domain/repositories/location_tracking_repository.dart';

class LocationTrackingRepositoryImpl extends LocationTrackingRepository {
  const LocationTrackingRepositoryImpl({
    required this.iosLocationTrackingLocalDataSource,
  });

  final IOSLocationTrackingLocalDataSource iosLocationTrackingLocalDataSource;
  @override
  Stream<Activity> activityChangeStream() {
    // TODO: implement activityChangeStream
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Location>>> getLocationsByDate({
    required DateTime start,
    required DateTime end,
  }) {
    // TODO: implement getLocationsByDate
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, None>> initTracking() async {
    await iosLocationTrackingLocalDataSource.initTracking();

    return const Right(None());
  }

  @override
  Stream<Location> locationChangeStream() {
    return iosLocationTrackingLocalDataSource.locationChangeStream();
  }

  @override
  Future<Either<Failure, None>> saveLocation(Location location) {
    // TODO: implement saveLocation
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, None>> saveMovementSegment({
    required MovementSegment movementSegment,
  }) {
    // TODO: implement saveMovementSegment
    throw UnimplementedError();
  }
}
