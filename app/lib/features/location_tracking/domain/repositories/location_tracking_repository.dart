import 'package:location_history/features/location_tracking/domain/models/recorded_location.dart';

/// {@template location_tracking_repository}
/// Repository contract for background location tracking.
///
/// The domain layer depends on this contract to start or stop tracking, receive
/// raw location updates, and tune how frequently movement is reported.
/// {@endtemplate}
abstract class LocationTrackingRepository {
  /// {@macro location_tracking_repository}
  const LocationTrackingRepository();

  /// Initializes the tracking service.
  ///
  /// This method should be called before [locationChangeStream] or
  /// [updateDistanceFilter].
  Future<void> initTracking();

  /// Stops the tracking service.
  Future<void> stopTracking();

  /// Streams raw location updates emitted by the tracking service.
  ///
  /// [initTracking] must be called before subscribing to this stream.
  ///
  /// Emits:
  /// - [RecordedLocation] values reported by the device
  Stream<RecordedLocation> locationChangeStream();
}
