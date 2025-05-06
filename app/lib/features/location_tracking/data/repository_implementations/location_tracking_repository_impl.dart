import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/location_tracking/data/datasources/ios_location_tracking_local_data_source.dart';
import 'package:location_history/features/location_tracking/domain/models/recorded_location.dart';
import 'package:location_history/features/location_tracking/domain/repositories/location_tracking_repository.dart';

class LocationTrackingRepositoryImpl extends LocationTrackingRepository {
  const LocationTrackingRepositoryImpl({
    required this.iosLocationTrackingLocalDataSource,
  });

  final IOSLocationTrackingLocalDataSource iosLocationTrackingLocalDataSource;

  @override
  Future<Either<Failure, None>> initTracking() async {
    await iosLocationTrackingLocalDataSource.initTracking();

    return const Right(None());
  }

  @override
  Stream<RecordedLocation> locationChangeStream() {
    return iosLocationTrackingLocalDataSource.locationChangeStream();
  }
}
