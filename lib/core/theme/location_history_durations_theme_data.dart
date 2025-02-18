part of 'location_history_theme.dart';

/// __Location History Durations Theme Data__
///
/// A collection of durations for the [LocationHistoryTheme].
class LocationHistoryDurationsThemeData {
  const LocationHistoryDurationsThemeData({
    Duration? short,
  }) : this._(
          short,
        );

  const LocationHistoryDurationsThemeData._(
    this._short,
  );

  final Duration? _short;

  Duration get short => _short ?? _DefaultDurations.short;
}
