/// {@template location_history_item}
/// Shared timeline contract for map history entries.
///
/// A [LocationHistoryItem] represents a chronological interval displayed by
/// the map history UI. Concrete entries can be stationary places or movement
/// activities, but every item exposes an ID and start/end timestamps so callers
/// can sort, group, and render a single mixed timeline.
/// {@endtemplate}
abstract class LocationHistoryItem {
  /// {@macro location_history_item}
  const LocationHistoryItem();

  String get id;

  DateTime get startTime;

  DateTime get endTime;
}
