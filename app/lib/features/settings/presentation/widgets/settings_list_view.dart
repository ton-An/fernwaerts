import 'package:flutter/material.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

/// {@template settings_list_view}
/// Shared scrollable layout for settings pages.
///
/// Applies the common settings padding and bouncing scroll physics.
/// {@endtemplate}
class SettingsListView extends StatelessWidget {
  /// {@macro settings_list_view}
  const SettingsListView({super.key, required this.children});

  /// Settings rows and sections displayed by the page.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return ListView(
      padding: EdgeInsets.only(
        top: theme.spacing.xLarge + theme.spacing.medium,
        bottom: theme.spacing.large,
        left: theme.spacing.medium,
        right: theme.spacing.medium,
      ),
      physics: const BouncingScrollPhysics(),
      children: children,
    );
  }
}
