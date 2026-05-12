import 'package:location_history/core/failures/storage/database_read_failure.dart';
import 'package:location_history/features/location_tracking/domain/models/location.dart';
import 'package:location_history/features/location_tracking/domain/models/movement_segment.dart';

/// Repository contract for persisted location history data.
abstract class LocationDataRepository {
  const LocationDataRepository();

  /// Saves a recorded location.
  ///
  /// Parameters:
  /// - location: The [Location] to save
  Future<void> saveLocation({required Location location});

  /// Gets locations recorded within a date range.
  ///
  /// Parameters:
  /// - start: Start [DateTime] of the range
  /// - end: End [DateTime] of the range
  ///
  /// Returns:
  /// - [Stream] of [List]s of [Location]s within the range
  Future<Stream<List<Location>>> getLocationsByDate({
    required DateTime start,
    required DateTime end,
  });

  /// Saves a movement segment.
  ///
  /// Parameters:
  /// - movementSegment: The [MovementSegment] to save
  ///
  /// Failures:
  /// - [DatabaseReadFailure]
  Future<void> saveMovementSegment({required MovementSegment movementSegment});
}
