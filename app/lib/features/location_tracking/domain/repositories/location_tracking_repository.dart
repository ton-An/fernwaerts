import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/location_tracking/domain/models/recorded_location.dart';

abstract class LocationTrackingRepository {
  const LocationTrackingRepository();

  /// Initializes the tracking service
  ///
  /// #### This method should be called when the app is started to ensure that the location tracking service is ready to use.
  ///
  /// Failures:
  /// - ...TBD
  Future<Either<Failure, None>> initTracking();

  /// Streams location updates
  ///
  /// #### Needs [initTracking] to be called before this method
  ///
  /// Emits:
  /// - [RecordedLocation] the current location of the user
  Stream<RecordedLocation> locationChangeStream();
}
