part of 'location_history_theme.dart';

/// __Location History Misc Theme Data__
///
/// A collection of miscellaneous values for the [LocationHistoryTheme].
class LocationHistoryMiscThemeData {
  const LocationHistoryMiscThemeData({
    double? largeIconSize,
    ImageFilter? blurFilter,
  }) : this._(
          largeIconSize,
          blurFilter,
        );

  const LocationHistoryMiscThemeData._(
    this._largeIconSize,
    this._blurFilter,
  );

  final double? _largeIconSize;
  final ImageFilter? _blurFilter;

  double get largeIconSize => _largeIconSize ?? _DefaultMisc.largeIconSize;
  ImageFilter get blurFilter => _blurFilter ?? _DefaultMisc.blurFilter;
}
