part of 'user_management_settings_page.dart';

class _User extends StatelessWidget {
  const _User({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: theme.spacing.xSmall),
      padding: EdgeInsets.symmetric(
        vertical: theme.spacing.medium,
        horizontal: theme.spacing.medium,
      ),
      decoration: BoxDecoration(
        color: theme.colors.translucentBackgroundContrast,
        borderRadius: BorderRadius.circular(theme.radii.medium),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.username,
                  style: theme.text.body.copyWith(fontWeight: FontWeight.w600),
                ),
                const SmallGap(),
                Text(user.email, style: theme.text.body),
              ],
            ),
          ),
          const XSmallGap(),
          Icon(
            CupertinoIcons.chevron_right,
            color: theme.colors.backgroundContrast,
          ),
        ],
      ),
    );
  }
}
