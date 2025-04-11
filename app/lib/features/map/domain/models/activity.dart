import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:location_history/features/map/domain/models/coordinate.dart';
import 'package:location_history/features/map/domain/models/location_history_item.dart';

part 'activity.freezed.dart';

enum ActivityType { running, cycling, walking, driving }

@freezed
sealed class Activity extends LocationHistoryItem with _$Activity {
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
