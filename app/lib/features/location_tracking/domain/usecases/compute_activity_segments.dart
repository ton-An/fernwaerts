import 'dart:math';

import 'package:location_history/features/location_tracking/domain/enums/activity_type.dart';
import 'package:location_history/features/location_tracking/domain/models/activity_segment.dart';
import 'package:location_history/features/location_tracking/domain/models/location.dart';
import 'package:location_history/features/location_tracking/domain/repositories/location_data_repository.dart';

/// {@template compute_activity_segments}
/// Computes and persists activity segments from raw location points.
///
/// The first implementation derives movement intervals between inferred
/// stationary place boundaries for the currently loaded locations.
/// {@endtemplate}
class ComputeActivitySegments {
  /// {@macro compute_activity_segments}
  const ComputeActivitySegments({required this.locationDataRepository});

  static const double _unknownMovementSpeedThreshold = 1;
  static const Duration _minimumStationaryGap = Duration(minutes: 5);
  static const double _stationaryImpliedSpeedThreshold = 0.5;
  static const double _earthRadiusInMeters = 6371000;

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
    final List<_PlaceBoundary> placeBoundaries = _derivePlaceBoundaries(
      locations,
    );
    final List<ActivitySegment> activitySegments = [];

    for (int i = 0; i < placeBoundaries.length - 1; i++) {
      _addSegmentIfValid(
        activitySegments: activitySegments,
        segmentStart: placeBoundaries[i].departureLocation,
        segmentEnd: placeBoundaries[i + 1].arrivalLocation,
      );
    }

    return activitySegments;
  }

  List<_PlaceBoundary> _derivePlaceBoundaries(List<Location> locations) {
    final List<_PlaceBoundary> placeBoundaries = [];
    Location? pendingArrivalLocation;
    Location? lastMovingLocation;

    for (final Location location in locations) {
      if (_isMoving(location)) {
        if (pendingArrivalLocation != null) {
          placeBoundaries.add(
            _PlaceBoundary(
              arrivalLocation: pendingArrivalLocation,
              departureLocation: location,
            ),
          );
          pendingArrivalLocation = null;
        } else if (lastMovingLocation != null &&
            _hasStationaryGap(
              previousLocation: lastMovingLocation,
              location: location,
            )) {
          placeBoundaries.add(
            _PlaceBoundary(
              arrivalLocation: lastMovingLocation,
              departureLocation: location,
            ),
          );
        }

        lastMovingLocation = location;
        continue;
      }

      pendingArrivalLocation ??= lastMovingLocation;
    }

    return placeBoundaries;
  }

  bool _hasStationaryGap({
    required Location previousLocation,
    required Location location,
  }) {
    final Duration elapsed = location.timestamp.difference(
      previousLocation.timestamp,
    );

    if (elapsed <= _minimumStationaryGap) {
      return false;
    }

    final double distanceInMeters = _distanceInMeters(
      from: previousLocation,
      to: location,
    );
    final double impliedSpeedInMetersPerSecond =
        distanceInMeters / elapsed.inMilliseconds * 1000;

    return impliedSpeedInMetersPerSecond < _stationaryImpliedSpeedThreshold;
  }

  double _distanceInMeters({required Location from, required Location to}) {
    final double fromLatitude = _degreesToRadians(from.latitude);
    final double toLatitude = _degreesToRadians(to.latitude);
    final double latitudeDelta = _degreesToRadians(to.latitude - from.latitude);
    final double longitudeDelta = _degreesToRadians(
      to.longitude - from.longitude,
    );

    final double haversine =
        pow(sin(latitudeDelta / 2), 2).toDouble() +
        cos(fromLatitude) *
            cos(toLatitude) *
            pow(sin(longitudeDelta / 2), 2).toDouble();

    return 2 * _earthRadiusInMeters * asin(sqrt(haversine));
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
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

class _PlaceBoundary {
  const _PlaceBoundary({
    required this.arrivalLocation,
    required this.departureLocation,
  });

  final Location arrivalLocation;
  final Location departureLocation;
}
