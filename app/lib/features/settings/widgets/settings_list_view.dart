import 'package:flutter/material.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

class SettingsListView extends StatelessWidget {
  const SettingsListView({super.key, required this.children});

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
      children: children,
    );
  }
}
