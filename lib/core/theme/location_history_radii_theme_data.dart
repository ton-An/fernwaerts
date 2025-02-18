part of 'location_history_theme.dart';

/// __Location History Radii Theme Data__
///
/// A collection of Cupertino radii values for the [LocationHistoryTheme].
class LocationHistoryRadiiThemeData {
  const LocationHistoryRadiiThemeData({
    double? small,
    double? medium,
    double? button,
    double? field,
  }) : this._(
          small,
          medium,
          button,
          field,
        );

  const LocationHistoryRadiiThemeData._(
    this._small,
    this._medium,
    this._button,
    this._field,
  );

  final double? _small;
  final double? _medium;
  final double? _button;
  final double? _field;

  double get small => _small ?? _DefaultRadii.small;
  double get medium => _medium ?? _DefaultRadii.medium;
  double get button => _button ?? _DefaultRadii.button;
  double get field => _field ?? _DefaultRadii.field;
}
