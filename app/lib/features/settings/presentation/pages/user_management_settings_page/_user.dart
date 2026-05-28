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
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);
    final bool invitePending = user.username.trim().isEmpty;

    return Container(
      margin: EdgeInsets.only(bottom: theme.spacing.xxSmall),
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.medium,
        vertical: theme.spacing.medium,
      ),
      decoration: BoxDecoration(
        color: theme.colors.translucentBackgroundContrast,
        borderRadius: BorderRadius.circular(theme.radii.medium),
      ),
      child: Row(
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: theme.colors.backgroundContrast.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              CupertinoIcons.person,
              color: theme.colors.backgroundContrast,
              size: 20,
            ),
          ),
          const XXSmallGap(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!invitePending) ...[
                  Text(
                    user.username,
                    style: theme.text.headline.copyWith(height: 1),
                  ),
                  const SmallGap(),
                ],
                Text(
                  user.email,
                  style: theme.text.body.copyWith(height: 1),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const XSmallGap(),
          if (invitePending) _PendingInviteBadge(label: localizations.pending),
        ],
      ),
    );
  }
}

class _PendingInviteBadge extends StatelessWidget {
  const _PendingInviteBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: theme.spacing.small + theme.spacing.xTiny,
        horizontal: theme.spacing.xSmall,
      ),
      decoration: BoxDecoration(
        color: theme.colors.translucentBackgroundContrast,
        borderRadius: BorderRadius.circular(theme.radii.small),
      ),
      child: Text(label, style: theme.text.headline.copyWith(height: 1)),
    );
  }
}
