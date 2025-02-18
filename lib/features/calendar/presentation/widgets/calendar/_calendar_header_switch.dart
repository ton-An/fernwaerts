part of 'calendar.dart';

class _Switch extends StatelessWidget {
  const _Switch({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final LocationHistoryThemeData theme = LocationHistoryTheme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.all(theme.spacing.xMedium - theme.spacing.small),
        child: Icon(
          icon,
          color: theme.colors.text,
        ),
      ),
    );
  }
}
