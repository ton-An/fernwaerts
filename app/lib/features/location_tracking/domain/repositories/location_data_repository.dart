import 'package:location_history/features/location_tracking/domain/models/location.dart';
import 'package:location_history/features/location_tracking/domain/models/activity_segment.dart';

/// {@template location_data_repository}
/// Repository contract for persisted location history data.
///
/// Implementations are responsible for storage and sync details. Callers should
/// use this contract for user-scoped location reads and saving recorded
/// locations.
/// {@endtemplate}
abstract class LocationDataRepository {
  /// {@macro location_data_repository}
  const LocationDataRepository();

  /// Saves a recorded location.
  ///
  /// Parameters:
  /// - location: [Location] to save
  Future<void> saveLocation({required Location location});

  /// Watches locations recorded within a date range.
  ///
  /// Parameters:
  /// - start: [DateTime] to start the range at
  /// - end: [DateTime] to end the range at
  ///
  /// Returns:
  /// - [Future] that resolves to a [Stream] of [List]s of [Location]s within
  ///   the range
  Future<Stream<List<Location>>> getLocationsByDate({
    required DateTime start,
    required DateTime end,
  });

  /// Saves an activity segment.
  ///
  /// Parameters:
  /// - activitySegment: [ActivitySegment] to save
  Future<void> saveActivitySegment({required ActivitySegment activitySegment});
}
