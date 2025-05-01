import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/location_tracking/domain/models/activity.dart';
import 'package:location_history/features/location_tracking/domain/models/location.dart';
import 'package:location_history/features/location_tracking/domain/models/movement_segment.dart';

abstract class LocationTrackingRepository {
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
  /// - [Location] the current location of the user
  Stream<Location> locationChangeStream();

  /// Streams activity updates
  ///
  /// #### Needs [initTracking] to be called before this method
  ///
  /// Emits:
  /// - [Activity] the current activity of the user
  Stream<Activity> activityChangeStream();

  /// Save location
  ///
  /// Parameters:
  /// - [Location] the location to save
  ///
  /// Failures:
  /// - ...TBD
  Future<Either<Failure, None>> saveLocation(Location location);

  /// Get locations by date range
  ///
  /// Parameters:
  /// - [DateTime] the start date of the range
  /// - [DateTime] the end date of the range
  ///
  /// Returns:
  /// - List of [Location]s within the date range
  ///
  /// Failures:
  /// - ...TBD
  Future<Either<Failure, List<Location>>> getLocationsByDate({
    required DateTime start,
    required DateTime end,
  });

  /// Saves a movement segment
  ///
  /// Parameters:
  /// - [MovementSegment] the segment to save
  ///
  /// Failures:
  /// - ...TBD
  Future<Either<Failure, None>> saveMovementSegment({
    required MovementSegment movementSegment,
  });
}
