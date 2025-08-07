import 'package:location_history/core/failures/storage/database_read_failure.dart';
import 'package:location_history/features/location_tracking/domain/models/location.dart';
import 'package:location_history/features/location_tracking/domain/models/movement_segment.dart';

abstract class LocationDataRepository {
  const LocationDataRepository();

  /// Save location
  ///
  /// Parameters:
  /// - [Location] the location to save
  Future<void> saveLocation({required Location location});

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
  /// - [DatabaseReadFailure]
  Future<List<Location>> getLocationsByDate({
    required DateTime start,
    required DateTime end,
  });

  /// Saves a movement segment
  ///
  /// Parameters:
  /// - [MovementSegment] the segment to save
  ///
  /// Failures:
  /// - [DatabaseReadFailure]
  Future<void> saveMovementSegment({required MovementSegment movementSegment});
}
