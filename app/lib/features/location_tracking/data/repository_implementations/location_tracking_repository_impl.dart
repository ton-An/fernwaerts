import 'package:location_history/features/location_tracking/data/datasources/ios_location_tracking_local_data_source.dart';
import 'package:location_history/features/location_tracking/domain/models/recorded_location.dart';
import 'package:location_history/features/location_tracking/domain/repositories/location_tracking_repository.dart';

/// {@template location_tracking_repository_impl}
/// A class that represents location tracking repository impl.
/// {@endtemplate}
class LocationTrackingRepositoryImpl extends LocationTrackingRepository {
/// {@macro location_tracking_repository_impl}
  const LocationTrackingRepositoryImpl({
    required this.iosLocationTrackingLocalDataSource,
  });

  final IOSLocationTrackingLocalDataSource iosLocationTrackingLocalDataSource;

  @override
  Future<void> initTracking() async {
    await iosLocationTrackingLocalDataSource.initTracking();
  }

  @override
  Future<void> stopTracking() async {
    await iosLocationTrackingLocalDataSource.stopTracking();
  }

  @override
  Stream<RecordedLocation> locationChangeStream() {
    return iosLocationTrackingLocalDataSource.locationChangeStream();
  }
}
