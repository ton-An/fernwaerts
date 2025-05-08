import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/storage/database_read_failure.dart';
import 'package:location_history/features/location_tracking/domain/models/location.model.dart';
import 'package:location_history/features/location_tracking/domain/models/movement_segment.dart';

abstract class LocationDataRepository {
  const LocationDataRepository();

  /// Save location
  ///
  /// Parameters:
  /// - [Location] the location to save
  ///
  /// Failures:
  /// - [DatabaseReadFailure]
  Future<Either<Failure, None>> saveLocation({required Location location});

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
  /// - [DatabaseReadFailure]
  Future<Either<Failure, None>> saveMovementSegment({
    required MovementSegment movementSegment,
  });
}
