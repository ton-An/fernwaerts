import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

/// {@template activity_segment}
/// Derived movement interval between two raw location points.
///
/// An [ActivitySegment] stores the first and last raw location IDs for one
/// continuous activity interval owned by a single user.
/// {@endtemplate}
class ActivitySegment extends Equatable {
  /// {@macro activity_segment}
  ActivitySegment({
    String? id,
    required this.userId,
    required this.startLocationId,
    required this.endLocationId,
  }) : id = id ?? const Uuid().v4();

  final String id;
  final String userId;
  final String startLocationId;
  final String endLocationId;

  @override
  List<Object?> get props => [id, userId, startLocationId, endLocationId];
}
