part of 'settings_page.dart';

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);
    return Container(
      margin: EdgeInsets.only(
        left: theme.spacing.medium,
        right: theme.spacing.medium,
        bottom: theme.spacing.medium,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.medium + theme.spacing.small,
        vertical: theme.spacing.medium + theme.spacing.small,
      ),
      decoration: BoxDecoration(
        color: theme.colors.translucentBackgroundContrast,
        borderRadius: BorderRadius.circular(theme.radii.medium),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SmallIconButton(
              icon: CupertinoIcons.back,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Text(
            AppLocalizations.of(context)!.settings,
            style: theme.text.title1.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 28),
        ],
      ),
    );
  }
}
