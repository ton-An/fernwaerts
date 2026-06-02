import 'package:equatable/equatable.dart';
import 'package:location_history/features/location_tracking/domain/enums/activity_type.dart';
import 'package:location_history/features/location_tracking/domain/models/location.dart';
import 'package:uuid/uuid.dart';

/// {@template activity_segment}
/// Derived movement interval between two raw location points.
///
/// An [ActivitySegment] stores the first and last raw locations for one
/// continuous activity interval, together with the dominant [ActivityType]
/// recorded across that interval.
/// {@endtemplate}
class ActivitySegment extends Equatable {
  /// {@macro activity_segment}
  ActivitySegment({
    String? id,
    required this.startLocation,
    required this.endLocation,
    required this.activityType,
  }) : id = id ?? const Uuid().v4();

  final String id;
  final Location startLocation;
  final Location endLocation;
  final ActivityType activityType;

  @override
  List<Object?> get props => [id, startLocation, endLocation, activityType];
}

/// Timeline helpers for an ordered list of [ActivitySegment]s.
extension ActivitySegmentTimeline on List<ActivitySegment> {
  /// Ordered locations that bound this activity timeline.
  ///
  /// Consecutive locations bound one segment: the first location is the start
  /// of the first segment, and every later location is a segment's end. The
  /// result therefore has one more entry than there are segments.
  List<Location> get boundaryLocations {
    if (isEmpty) {
      return const [];
    }

    return [
      first.startLocation,
      for (final ActivitySegment segment in this) segment.endLocation,
    ];
  }
}
