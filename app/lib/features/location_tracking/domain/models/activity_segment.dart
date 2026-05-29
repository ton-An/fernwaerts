import 'package:equatable/equatable.dart';
import 'package:location_history/features/location_tracking/domain/enums/activity_type.dart';
import 'package:uuid/uuid.dart';

/// {@template activity_segment}
/// Derived movement interval between two raw location points.
///
/// An [ActivitySegment] stores the first and last raw location IDs for one
/// continuous activity interval owned by a single user, together with the
/// dominant [ActivityType] recorded across that interval.
/// {@endtemplate}
class ActivitySegment extends Equatable {
  /// {@macro activity_segment}
  ActivitySegment({
    String? id,
    required this.userId,
    required this.startLocationId,
    required this.endLocationId,
    required this.activityType,
  }) : id = id ?? const Uuid().v4();

  final String id;
  final String userId;
  final String startLocationId;
  final String endLocationId;
  final ActivityType activityType;

  @override
  List<Object?> get props => [
    id,
    userId,
    startLocationId,
    endLocationId,
    activityType,
  ];
}

/// Timeline helpers for an ordered list of [ActivitySegment]s.
extension ActivitySegmentTimeline on List<ActivitySegment> {
  /// Ordered location IDs that bound this activity timeline.
  ///
  /// Consecutive IDs bound one segment: the first ID is the start of the first
  /// segment, and every later ID is a segment's end. The result therefore has
  /// one more entry than there are segments.
  List<String> get boundaryLocationIds {
    if (isEmpty) {
      return const [];
    }

    return [
      first.startLocationId,
      for (final ActivitySegment segment in this) segment.endLocationId,
    ];
  }
}
