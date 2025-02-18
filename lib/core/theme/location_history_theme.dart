import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

part '_default_misc.dart';
part '_default_radii.dart';
part '_default_spacing.dart';
part '_default_text_styles.dart';
part '_inherited_location_history_theme.dart';
part '_text_theme_defaults_builder.dart';
part 'location_history_color_theme_data.dart';
part 'location_history_colors.dart';
part 'location_history_misc_theme_data.dart';
part 'location_history_radii_theme_data.dart';
part 'location_history_spacing_theme_data.dart';
part 'location_history_text_theme_data.dart';
part 'location_history_theme_data.dart';

/// __Location History Theme__
///
/// A theme that is __inspired__ (please don't sue) by a certain company residing in an infinite loop.
class LocationHistoryTheme extends StatelessWidget {
  const LocationHistoryTheme({
    super.key,
    required this.data,
    required this.child,
  });

  final LocationHistoryThemeData data;
  final Widget child;

  static LocationHistoryThemeData of(BuildContext context) {
    final _InheritedLocationHistoryTheme? inheritedTheme = context
        .dependOnInheritedWidgetOfExactType<_InheritedLocationHistoryTheme>();
    return inheritedTheme?.theme.data ?? const LocationHistoryThemeData();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedLocationHistoryTheme(
      theme: this,
      child: child,
    );
  }
}
