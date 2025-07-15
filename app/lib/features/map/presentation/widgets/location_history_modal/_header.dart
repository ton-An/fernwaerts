part of 'location_history_modal.dart';

/// {@template header}
/// A header widget that displays  information.
/// {@endtemplate}
class _Header extends StatelessWidget {
/// {@macro header}
  const _Header();

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.medium,
        vertical: theme.spacing.medium + theme.spacing.small,
      ),
      decoration: BoxDecoration(
        color: theme.colors.translucentBackgroundContrast,
        borderRadius: BorderRadius.circular(theme.radii.medium),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: theme.spacing.xTiny),
            child: Text(
              AppLocalizations.of(context)!.yourHistory,
              style: theme.text.title1.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Row(
            children: [
              SmallIconButton(icon: CupertinoIcons.pencil, onPressed: () {}),
              const XXSmallGap(),
              SmallIconButton(
                icon: CupertinoIcons.settings,
                onPressed: () {
                  context.go(SettingsPage.route);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
