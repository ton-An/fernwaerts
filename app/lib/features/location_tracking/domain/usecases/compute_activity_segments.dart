import 'package:location_history/features/location_tracking/domain/enums/activity_type.dart';
import 'package:location_history/features/location_tracking/domain/models/activity_segment.dart';
import 'package:location_history/features/location_tracking/domain/models/location.dart';
import 'package:location_history/features/location_tracking/domain/repositories/location_data_repository.dart';

/// {@template compute_activity_segments}
/// Computes and persists activity segments from raw location points.
///
/// The first implementation uses conservative point-level activity signals to
/// derive continuous movement intervals for the currently loaded locations.
/// {@endtemplate}
class ComputeActivitySegments {
  /// {@macro compute_activity_segments}
  const ComputeActivitySegments({required this.locationDataRepository});

  static const double _unknownMovementSpeedThreshold = 1;

  final LocationDataRepository locationDataRepository;

  /// {@macro compute_activity_segments}
  ///
  /// Parameters:
  /// - locations: [List] of [Location] points to derive segments from
  ///
  /// Returns:
  /// - [List] of persisted [ActivitySegment] values
  ///
  /// Throws:
  /// - [ArgumentError] when [locations] contains multiple user IDs
  Future<List<ActivitySegment>> call({
    required List<Location> locations,
  }) async {
    if (locations.length < 2) {
      return const [];
    }

    _validateSingleUser(locations);

    final List<Location> sortedLocations = List<Location>.from(locations)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final List<ActivitySegment> activitySegments = _deriveActivitySegments(
      sortedLocations,
    );

    // for (final ActivitySegment activitySegment in activitySegments) {
    //   await locationDataRepository.saveActivitySegment(
    //     activitySegment: activitySegment,
    //   );
    // }

    return activitySegments;
  }

  void _validateSingleUser(List<Location> locations) {
    final String userId = locations.first.userId;
    final bool hasMixedUsers = locations.any(
      (Location location) => location.userId != userId,
    );

    if (hasMixedUsers) {
      throw ArgumentError('Cannot compute activity segments for mixed users.');
    }
  }

  List<ActivitySegment> _deriveActivitySegments(List<Location> locations) {
    final List<ActivitySegment> activitySegments = [];
    Location? segmentStart;
    Location? lastMovingLocation;

    for (final Location location in locations) {
      if (_isMoving(location)) {
        segmentStart ??= location;
        lastMovingLocation = location;
        continue;
      }

      if (segmentStart != null && lastMovingLocation != null) {
        _addSegmentIfValid(
          activitySegments: activitySegments,
          segmentStart: segmentStart,
          segmentEnd: lastMovingLocation,
        );
      }

      segmentStart = null;
      lastMovingLocation = null;
    }

    if (segmentStart != null && lastMovingLocation != null) {
      _addSegmentIfValid(
        activitySegments: activitySegments,
        segmentStart: segmentStart,
        segmentEnd: lastMovingLocation,
      );
    }

    return activitySegments;
  }

  void _addSegmentIfValid({
    required List<ActivitySegment> activitySegments,
    required Location segmentStart,
    required Location segmentEnd,
  }) {
    if (segmentStart.id == segmentEnd.id) {
      return;
    }

    activitySegments.add(
      ActivitySegment(
        userId: segmentStart.userId,
        startLocationId: segmentStart.id,
        endLocationId: segmentEnd.id,
      ),
    );
  }

  bool _isMoving(Location location) {
    switch (location.activityType) {
      case ActivityType.walking:
      case ActivityType.onFoot:
      case ActivityType.running:
      case ActivityType.onBicycle:
      case ActivityType.inVehicle:
        return true;
      case ActivityType.unknown:
        return location.speed > _unknownMovementSpeedThreshold;
      case ActivityType.still:
        return false;
    }
  }
}
