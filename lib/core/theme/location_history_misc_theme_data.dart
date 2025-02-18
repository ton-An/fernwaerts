part of 'location_history_theme.dart';

/// __Location History Misc Theme Data__
///
/// A collection of miscellaneous values for the [LocationHistoryTheme].
class LocationHistoryMiscThemeData {
  const LocationHistoryMiscThemeData({
    double? largeIconSize,
  }) : this._(
          largeIconSize,
        );

  const LocationHistoryMiscThemeData._(
    this._largeIconSize,
  );

  final double? _largeIconSize;

  double get largeIconSize => _largeIconSize ?? _DefaultMisc.largeIconSize;
}
