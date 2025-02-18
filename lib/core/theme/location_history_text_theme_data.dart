part of 'location_history_theme.dart';

/// __Location History Text Theme Data__
///
/// A collection of Cupertino text styles for the [LocationHistoryTheme].
class LocationHistoryTextThemeData {
  const LocationHistoryTextThemeData({
    TextStyle? largeTitle,
    TextStyle? title1,
    TextStyle? title2,
    TextStyle? title3,
    TextStyle? headline,
    TextStyle? body,
    TextStyle? callout,
    TextStyle? subhead,
    TextStyle? footnote,
    TextStyle? caption1,
    TextStyle? caption2,
  }) : this._raw(
          const _TextThemeDefaultsBuilder(
            LocationHistoryColors.black,
            LocationHistoryColors.description,
          ),
          largeTitle,
          title1,
          title2,
          title3,
          headline,
          body,
          callout,
          subhead,
          footnote,
          caption1,
          caption2,
        );

  const LocationHistoryTextThemeData._raw(
    this._defaults,
    this._largeTitle,
    this._title1,
    this._title2,
    this._title3,
    this._headline,
    this._body,
    this._callout,
    this._subhead,
    this._footnote,
    this._caption1,
    this._caption2,
  );

  final _TextThemeDefaultsBuilder _defaults;
  final TextStyle? _largeTitle;
  final TextStyle? _title1;
  final TextStyle? _title2;
  final TextStyle? _title3;
  final TextStyle? _headline;
  final TextStyle? _body;
  final TextStyle? _callout;
  final TextStyle? _subhead;
  final TextStyle? _footnote;
  final TextStyle? _caption1;
  final TextStyle? _caption2;

  TextStyle get largeTitle => _largeTitle ?? _defaults.largeTitle;
  TextStyle get title1 => _title1 ?? _defaults.title1;
  TextStyle get title2 => _title2 ?? _defaults.title2;
  TextStyle get title3 => _title3 ?? _defaults.title3;
  TextStyle get headline => _headline ?? _defaults.headline;
  TextStyle get body => _body ?? _defaults.body;
  TextStyle get callout => _callout ?? _defaults.callout;
  TextStyle get subhead => _subhead ?? _defaults.subhead;
  TextStyle get footnote => _footnote ?? _defaults.footnote;
  TextStyle get caption1 => _caption1 ?? _defaults.caption1;
  TextStyle get caption2 => _caption2 ?? _defaults.caption2;

  /// Returns a copy of the current [LocationHistoryTextThemeData] with all the colors
  /// resolved against the given [BuildContext].
  LocationHistoryTextThemeData resolveFrom(BuildContext context) {
    return LocationHistoryTextThemeData._raw(
      _defaults.resolveFrom(context),
      _resolveTextStyle(_largeTitle, context),
      _resolveTextStyle(_title1, context),
      _resolveTextStyle(_title2, context),
      _resolveTextStyle(_title3, context),
      _resolveTextStyle(_headline, context),
      _resolveTextStyle(_body, context),
      _resolveTextStyle(_callout, context),
      _resolveTextStyle(_subhead, context),
      _resolveTextStyle(_footnote, context),
      _resolveTextStyle(_caption1, context),
      _resolveTextStyle(_caption2, context),
    );
  }

  TextStyle? _resolveTextStyle(TextStyle? style, BuildContext context) {
    return style?.copyWith(
      color: style.color ?? LocationHistoryTheme.of(context).colors.text,
    );
  }
}
