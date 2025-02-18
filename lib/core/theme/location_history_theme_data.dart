part of 'location_history_theme.dart';

/// __Location History Theme Data__
///
/// The theme data of the [LocationHistoryTheme].
class LocationHistoryThemeData {
  const LocationHistoryThemeData({
    this.colors = const LocationHistoryColorThemeData(),
    this.text = const LocationHistoryTextThemeData(),
    this.spacing = const LocationHistorySpacingThemeData(),
    this.radii = const LocationHistoryRadiiThemeData(),
    this.misc = const LocationHistoryMiscThemeData(),
  });

  final LocationHistoryColorThemeData colors;
  final LocationHistoryTextThemeData text;
  final LocationHistorySpacingThemeData spacing;
  final LocationHistoryRadiiThemeData radii;
  final LocationHistoryMiscThemeData misc;
}
