import 'package:flutter/cupertino.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

class SettingsSectionTitle extends StatelessWidget {
  const SettingsSectionTitle({
    super.key,
    required this.title,
    this.description,
  });

  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.text.title1.copyWith(fontWeight: FontWeight.w600),
        ),
        if (description != null) ...[
          const SmallGap(),
          Text(
            description!,
            style: theme.text.body.copyWith(color: theme.colors.hint),
          ),
          const SmallGap(),
        ],
      ],
    );
  }
}
