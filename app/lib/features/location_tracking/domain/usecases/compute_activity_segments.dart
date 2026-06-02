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

  static const double _maximumPlaceAccuracyInMeters = 100;
  static const double _placeRadiusInMeters = 100;
  static const Duration _minimumPlaceDuration = Duration(minutes: 5);
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
    final List<_DetectedPlace> places = _derivePlaces(locations);
    final List<ActivitySegment> activitySegments = [];

    for (int i = 0; i < places.length - 1; i++) {
      final Location segmentStart = places[i].representativeLocation;
      final Location segmentEnd = places[i + 1].representativeLocation;

      if (segmentStart.id == segmentEnd.id) {
        continue;
      }

      if (_isWithinPlaceRadius(
        latitude: segmentStart.latitude,
        longitude: segmentStart.longitude,
        location: segmentEnd,
      )) {
        continue;
      }

      activitySegments.add(
        ActivitySegment(
          startLocation: segmentStart,
          endLocation: segmentEnd,
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

  List<_DetectedPlace> _derivePlaces(List<Location> locations) {
    final List<_DetectedPlace> places = [];
    _PlaceCandidate? currentCandidate;

    for (final Location location in locations) {
      if (!_hasUsableAccuracy(location)) {
        continue;
      }

      final _PlaceCandidate? candidate = currentCandidate;

      if (candidate == null) {
        currentCandidate = _PlaceCandidate(location);
        continue;
      }

      if (candidate.contains(location)) {
        candidate.add(location);
        continue;
      }

      final _DetectedPlace? detectedPlace = candidate.detectedPlace;
      if (detectedPlace != null) {
        places.add(detectedPlace);
      }

      currentCandidate = _PlaceCandidate(location);
    }

    final _DetectedPlace? detectedPlace = currentCandidate?.detectedPlace;
    if (detectedPlace != null) {
      places.add(detectedPlace);
    }

    return places;
  }

  bool _hasUsableAccuracy(Location location) {
    return location.coordinatesAccuracy > 0 &&
        location.coordinatesAccuracy <= _maximumPlaceAccuracyInMeters;
  }

  static bool _isWithinPlaceRadius({
    required double latitude,
    required double longitude,
    required Location location,
  }) {
    final double distanceInMeters = _distanceInMetersBetweenCoordinates(
      fromLatitude: latitude,
      fromLongitude: longitude,
      toLatitude: location.latitude,
      toLongitude: location.longitude,
    );

    return distanceInMeters <= _placeRadiusInMeters;
  }

  static double _distanceInMetersBetweenCoordinates({
    required double fromLatitude,
    required double fromLongitude,
    required double toLatitude,
    required double toLongitude,
  }) {
    final double fromLatitudeInRadians = _degreesToRadians(fromLatitude);
    final double toLatitudeInRadians = _degreesToRadians(toLatitude);
    final double latitudeDelta = _degreesToRadians(toLatitude - fromLatitude);
    final double longitudeDelta = _degreesToRadians(
      toLongitude - fromLongitude,
    );

    final double haversine =
        pow(sin(latitudeDelta / 2), 2).toDouble() +
        cos(fromLatitudeInRadians) *
            cos(toLatitudeInRadians) *
            pow(sin(longitudeDelta / 2), 2).toDouble();

    return 2 * _earthRadiusInMeters * asin(sqrt(haversine));
  }

  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  /// Most frequent moving activity type recorded between [segmentStart] and
  /// [segmentEnd]. Stationary and unknown samples are ignored, and [unknown] is
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
      return ActivityType.unknown;
    }

    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }
}

class _DetectedPlace {
  const _DetectedPlace({required this.representativeLocation});

  final Location representativeLocation;
}

class _PlaceCandidate {
  _PlaceCandidate(Location location) : _locations = [location] {
    _recalculateCenter();
  }

  final List<Location> _locations;

  late double _centerLatitude;
  late double _centerLongitude;

  _DetectedPlace? get detectedPlace {
    if (_locations.length < 2) {
      return null;
    }

    final Duration duration = _locations.last.timestamp.difference(
      _locations.first.timestamp,
    );

    if (duration < ComputeActivitySegments._minimumPlaceDuration) {
      return null;
    }

    return _DetectedPlace(representativeLocation: _representativeLocation);
  }

  Location get _representativeLocation {
    return _locations.reduce((Location best, Location location) {
      final double bestScore = _representativeScore(best);
      final double locationScore = _representativeScore(location);

      return locationScore < bestScore ? location : best;
    });
  }

  bool contains(Location location) {
    return ComputeActivitySegments._isWithinPlaceRadius(
      latitude: _centerLatitude,
      longitude: _centerLongitude,
      location: location,
    );
  }

  void add(Location location) {
    _locations.add(location);
    _recalculateCenter();
  }

  void _recalculateCenter() {
    _centerLatitude =
        _locations
            .map((Location location) => location.latitude)
            .reduce((double value, double element) => value + element) /
        _locations.length;
    _centerLongitude =
        _locations
            .map((Location location) => location.longitude)
            .reduce((double value, double element) => value + element) /
        _locations.length;
  }

  double _representativeScore(Location location) {
    final double distanceFromCenter =
        ComputeActivitySegments._distanceInMetersBetweenCoordinates(
          fromLatitude: _centerLatitude,
          fromLongitude: _centerLongitude,
          toLatitude: location.latitude,
          toLongitude: location.longitude,
        );

    return distanceFromCenter + location.coordinatesAccuracy;
  }
}
