import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:location_history/features/map/domain/models/coordinate.dart';
import 'package:location_history/features/map/domain/models/location_history_item.dart';

part 'activity.freezed.dart';

/// Derived movement category used by the map timeline.
///
/// These values describe display-level movement intervals, not the raw tracking
/// activity values persisted with individual location points.
enum ActivityType { running, cycling, walking, driving }

/// {@template activity}
/// Movement interval between two places or location clusters on the map.
///
/// An [Activity] summarizes travel over a period of time with a start
/// coordinate, end coordinate, display category, and total distance. It is a
/// [LocationHistoryItem] so it can be rendered alongside [Place] entries in one
/// chronological history.
/// {@endtemplate}
@freezed
sealed class Activity extends LocationHistoryItem with _$Activity {
  /// {@macro activity}
  ///
  /// Parameters:
  /// - id: [String] stable identifier for this timeline item
  /// - startTime: [DateTime] beginning of the movement interval
  /// - endTime: [DateTime] end of the movement interval
  /// - type: [ActivityType] display category for the movement
  /// - startCoordinate: [Coordinate] first coordinate in the interval
  /// - endCoordinate: [Coordinate] final coordinate in the interval
  /// - distance: [double] total distance traveled during the interval, in
  ///   meters
  const factory Activity({
    required String id,
    required DateTime startTime,
    required DateTime endTime,
    required ActivityType type,
    required Coordinate startCoordinate,
    required Coordinate endCoordinate,
    required double distance,
  }) = _Activity;

  const Activity._();
}
