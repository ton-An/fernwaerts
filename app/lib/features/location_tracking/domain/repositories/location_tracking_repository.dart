import 'package:location_history/features/location_tracking/domain/models/recorded_location.dart';

abstract class LocationTrackingRepository {
  const LocationTrackingRepository();

  /// Initializes the tracking service
  ///
  /// #### This method should be called when the app is started to ensure that the location tracking service is ready to use.
  Future<void> initTracking();

  /// Stops the tracking service
  Future<void> stopTracking();

  /// Streams location updates
  ///
  /// #### Needs [initTracking] to be called before this method
  ///
  /// Emits:
  /// - [RecordedLocation] the current location of the user
  Stream<RecordedLocation> locationChangeStream();

  /// Updates the distance filter for the tracking service.
  ///
  /// #### Needs [initTracking] to be called before this
  ///
  /// Parameters:
  /// - [distanceFilter] the distance in meters that must be traveled before a new location is recorded
  Future<void> updateDistanceFilter({required double distanceFilter});
}
