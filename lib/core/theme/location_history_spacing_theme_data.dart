part of 'location_history_theme.dart';

/// __Location History Spacing Theme Data__
///
/// A collection of Cupertino spacing values for the [LocationHistoryTheme].
class LocationHistorySpacingThemeData {
  const LocationHistorySpacingThemeData({
    double? tiny,
    double? xTiny,
    double? small,
    double? xSmall,
    double? xxSmall,
    double? medium,
    double? xMedium,
    double? xxMedium,
    double? large,
    double? xLarge,
    double? xxLarge,
  }) : this._(
          tiny,
          xTiny,
          small,
          xSmall,
          xxSmall,
          medium,
          xMedium,
          xxMedium,
          large,
          xLarge,
          xxLarge,
        );

  const LocationHistorySpacingThemeData._(
    this._tiny,
    this._xTiny,
    this._small,
    this._xSmall,
    this._xxSmall,
    this._medium,
    this._xMedium,
    this._xxMedium,
    this._large,
    this._xLarge,
    this._xxLarge,
  );

  final double? _tiny;
  final double? _xTiny;
  final double? _small;
  final double? _xSmall;
  final double? _xxSmall;
  final double? _medium;
  final double? _xMedium;
  final double? _xxMedium;
  final double? _large;
  final double? _xLarge;
  final double? _xxLarge;

  double get tiny => _tiny ?? _DefaultSpacing.tiny;
  double get xTiny => _xTiny ?? _DefaultSpacing.xTiny;
  double get small => _small ?? _DefaultSpacing.small;
  double get xSmall => _xSmall ?? _DefaultSpacing.xSmall;
  double get xxSmall => _xxSmall ?? _DefaultSpacing.xxSmall;
  double get medium => _medium ?? _DefaultSpacing.medium;
  double get xMedium => _xMedium ?? _DefaultSpacing.xMedium;
  double get xxMedium => _xxMedium ?? _DefaultSpacing.xxMedium;
  double get large => _large ?? _DefaultSpacing.large;
  double get xLarge => _xLarge ?? _DefaultSpacing.xLarge;
  double get xxLarge => _xxLarge ?? _DefaultSpacing.xxLarge;
}
