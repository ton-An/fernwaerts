import 'package:flutter/cupertino.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

/// {@template settings_page_link}
/// Tappable settings row that navigates to another settings page.
/// {@endtemplate}
class SettingsPageLink extends StatelessWidget {
  /// {@macro settings_page_link}
  const SettingsPageLink({
    super.key,
    required this.title,
    required this.onPressed,
    this.semanticLabel,
    this.showDivider = true,
  });

  /// Row label.
  final String title;

  /// Callback invoked when the row or trailing icon is tapped.
  final VoidCallback onPressed;

  /// Optional accessibility label for the tappable row.
  final String? semanticLabel;

  /// Whether to show the divider below this row.
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return FadeTapDetector(
      semanticLabel: semanticLabel,
      onTap: onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: theme.spacing.xSmall),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: theme.text.body.copyWith()),
                Padding(
                  padding: EdgeInsets.all(theme.spacing.xSmall),
                  child: Transform.translate(
                    offset: const Offset(1, 0),
                    child: Icon(
                      CupertinoIcons.forward,
                      color: theme.colors.text,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (showDivider)
            Container(
              height: 1,
              color: theme.colors.translucentBackgroundContrast,
            ),
        ],
      ),
    );
  }
}
