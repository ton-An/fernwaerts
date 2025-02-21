part of 'location_history_theme.dart';

/// __Location History Radii Theme Data__
///
/// A collection of Cupertino radii values for the [LocationHistoryTheme].
class LocationHistoryRadiiThemeData {
  const LocationHistoryRadiiThemeData({
    double? small,
    double? medium,
    double? large,
    double? xLarge,
    double? button,
    double? field,
  }) : this._(
          small,
          medium,
          large,
          xLarge,
          button,
          field,
        );

  const LocationHistoryRadiiThemeData._(
    this._small,
    this._medium,
    this._large,
    this._xLarge,
    this._button,
    this._field,
  );

  final double? _small;
  final double? _medium;
  final double? _large;
  final double? _xLarge;
  final double? _button;
  final double? _field;

  double get small => _small ?? _DefaultRadii.small;
  double get medium => _medium ?? _DefaultRadii.medium;
  double get large => _large ?? _DefaultRadii.large;
  double get xLarge => _xLarge ?? _DefaultRadii._xLarge;
  double get button => _button ?? _DefaultRadii.button;
  double get field => _field ?? _DefaultRadii.field;
}
