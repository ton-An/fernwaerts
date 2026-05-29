import 'dart:math';

import 'package:location_history/features/location_tracking/domain/enums/activity_type.dart';
import 'package:location_history/features/location_tracking/domain/models/activity_segment.dart';
import 'package:location_history/features/location_tracking/domain/models/location.dart';

/// {@template compute_activity_segments}
/// Computes activity segments from raw location points.
///
/// A segment is the movement interval between two inferred stationary places:
/// it spans from the departure of one place to the arrival at the next, and
/// carries the dominant activity type recorded across that interval.
///
/// Parameters:
/// - locations: [List] of [Location] points to derive segments from
///
/// Returns:
/// - [List] of [ActivitySegment] values ordered by time
/// {@endtemplate}
class ComputeActivitySegments {
  /// {@macro compute_activity_segments}
  const ComputeActivitySegments();

  static const double _unknownMovementSpeedThreshold = 1;
  static const Duration _minimumStationaryGap = Duration(minutes: 5);
  static const double _stationaryImpliedSpeedThreshold = 0.5;
  static const double _earthRadiusInMeters = 6371000;

  /// {@macro compute_activity_segments}
  List<ActivitySegment> call({required List<Location> locations}) {
    if (locations.length < 2) {
      return const [];
    }

    final List<Location> sortedLocations = List<Location>.from(locations)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return _deriveActivitySegments(sortedLocations);
  }

  List<ActivitySegment> _deriveActivitySegments(List<Location> locations) {
    final List<_PlaceBoundary> placeBoundaries = _derivePlaceBoundaries(
      locations,
    );
    final List<ActivitySegment> activitySegments = [];

    for (int i = 0; i < placeBoundaries.length - 1; i++) {
      final Location segmentStart = placeBoundaries[i].departureLocation;
      final Location segmentEnd = placeBoundaries[i + 1].arrivalLocation;

      if (segmentStart.id == segmentEnd.id) {
        continue;
      }

      activitySegments.add(
        ActivitySegment(
          userId: segmentStart.userId,
          startLocationId: segmentStart.id,
          endLocationId: segmentEnd.id,
          activityType: _dominantActivityType(
            locations: locations,
            segmentStart: segmentStart,
            segmentEnd: segmentEnd,
          ),
        ),
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

  /// Most frequent moving activity type recorded between [segmentStart] and
  /// [segmentEnd]. Stationary and unknown samples are ignored, and [walking] is
  /// used when no moving samples fall in the interval.
  ActivityType _dominantActivityType({
    required List<Location> locations,
    required Location segmentStart,
    required Location segmentEnd,
  }) {
    final Map<ActivityType, int> counts = {};

    for (final Location location in locations) {
      if (location.timestamp.isBefore(segmentStart.timestamp) ||
          location.timestamp.isAfter(segmentEnd.timestamp)) {
        continue;
      }
      if (location.activityType == ActivityType.still ||
          location.activityType == ActivityType.unknown) {
        continue;
      }

      counts.update(
        location.activityType,
        (int value) => value + 1,
        ifAbsent: () => 1,
      );
    }

    if (counts.isEmpty) {
      return ActivityType.walking;
    }

    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
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
