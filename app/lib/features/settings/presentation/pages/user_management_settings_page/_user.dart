part of 'user_management_settings_page.dart';

/// {@template user_management_user}
/// Displays a user row in the user-management settings list.
/// {@endtemplate}
class _User extends StatelessWidget {
  /// {@macro user_management_user}
  const _User({required this.user});

  /// User information displayed by this row.
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
