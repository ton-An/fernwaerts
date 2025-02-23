part of 'location_history_modal.dart';

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final LocationHistoryThemeData theme = LocationHistoryTheme.of(context);
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
              'Your History',
              style: theme.text.title1.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Row(
            children: [
              _SmallIconButton(icon: CupertinoIcons.pencil),
              XXSmallGap(),
              _SmallIconButton(icon: CupertinoIcons.settings),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallIconButton extends StatelessWidget {
  const _SmallIconButton({
    required this.icon,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final LocationHistoryThemeData theme = LocationHistoryTheme.of(context);

    return Container(
      padding: EdgeInsets.all(theme.spacing.xSmall),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colors.translucentBackgroundContrast,
      ),
      child: Icon(
        icon,
        color: theme.colors.text,
      ),
    );
  }
}
