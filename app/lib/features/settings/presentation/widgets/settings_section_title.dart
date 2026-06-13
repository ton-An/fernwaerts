import 'package:flutter/cupertino.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

/// {@template settings_section_title}
/// Section heading used by settings pages.
///
/// An optional [description] is shown below the title with secondary styling.
/// {@endtemplate}
class SettingsSectionTitle extends StatelessWidget {
  /// {@macro settings_section_title}
  const SettingsSectionTitle({
    super.key,
    required this.title,
    this.description,
  });

  /// Section title text.
  final String title;

  /// Optional explanatory text shown below [title].
  final String? description;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.text.title1),
        if (description != null) ...[
          const SmallGap(),
          Text(
            description!,
            style: theme.text.body.copyWith(color: theme.colors.hint),
          ),
          const MediumGap(),
        ],
      ],
    );
  }
}
