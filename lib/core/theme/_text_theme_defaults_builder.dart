part of 'location_history_theme.dart';

@immutable
class _TextThemeDefaultsBuilder {
  const _TextThemeDefaultsBuilder(
    this.color,
    this.descriptionColor,
  );

  final Color color;
  final Color descriptionColor;

  static TextStyle _applyLabelColor(TextStyle original, Color color) {
    return original.color == color ? original : original.copyWith(color: color);
  }

  TextStyle get largeTitle =>
      _applyLabelColor(_DefaultTextStyles.largeTitle, color);
  TextStyle get title1 => _applyLabelColor(_DefaultTextStyles.title1, color);
  TextStyle get title2 => _applyLabelColor(_DefaultTextStyles.title2, color);
  TextStyle get title3 => _applyLabelColor(_DefaultTextStyles.title3, color);
  TextStyle get headline =>
      _applyLabelColor(_DefaultTextStyles.headline, color);
  TextStyle get body => _applyLabelColor(_DefaultTextStyles.body, color);
  TextStyle get callout => _applyLabelColor(_DefaultTextStyles.callout, color);
  TextStyle get subhead => _applyLabelColor(_DefaultTextStyles.subhead, color);
  TextStyle get footnote =>
      _applyLabelColor(_DefaultTextStyles.footnote, descriptionColor);
  TextStyle get caption1 =>
      _applyLabelColor(_DefaultTextStyles.caption1, descriptionColor);
  TextStyle get caption2 =>
      _applyLabelColor(_DefaultTextStyles.caption2, descriptionColor);

  _TextThemeDefaultsBuilder resolveFrom(BuildContext context) {
    final Color resolvedColor = LocationHistoryTheme.of(context).colors.text;
    final Color resolvedDescriptionColor =
        LocationHistoryTheme.of(context).colors.description;

    return resolvedColor == color &&
            resolvedDescriptionColor == descriptionColor
        ? this
        : _TextThemeDefaultsBuilder(resolvedColor, resolvedDescriptionColor);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is _TextThemeDefaultsBuilder &&
        other.color == color &&
        other.descriptionColor == descriptionColor;
  }

  @override
  int get hashCode => Object.hash(color, descriptionColor);
}
