part of 'location_history_theme.dart';

/// __Location History Theme__
///
/// A wrapper for the [Theme] widget that provides an [LocationHistoryThemeData] to its
/// children via [InheritedWidget].
class _InheritedLocationHistoryTheme extends InheritedWidget {
  const _InheritedLocationHistoryTheme({
    required this.theme,
    required super.child,
  });

  final LocationHistoryTheme theme;

  @override
  bool updateShouldNotify(_InheritedLocationHistoryTheme old) =>
      theme.data != old.theme.data;
}
