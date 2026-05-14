import 'package:flutter/cupertino.dart';
import 'package:location_history/core/widgets/fade_tap_detector.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

/// {@template sub_settings_page_link}
/// Tappable settings row that navigates to another settings page.
/// {@endtemplate}
class SubSettingsPageLink extends StatelessWidget {
  /// {@macro sub_settings_page_link}
  const SubSettingsPageLink({
    super.key,
    required this.title,
    required this.onPressed,
    this.showDivider = true,
  });

  /// Row label.
  final String title;

  /// Callback invoked when the row or trailing icon is tapped.
  final VoidCallback onPressed;

  /// Whether to show the divider below this row.
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return FadeTapDetector(
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
                SmallIconButton(
                  icon: CupertinoIcons.forward,
                  onPressed: onPressed,
                  alignmentOffset: const Offset(1, 0),
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
