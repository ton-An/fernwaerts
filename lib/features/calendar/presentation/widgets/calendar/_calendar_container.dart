part of 'calendar.dart';

class _CalendarContainer extends StatelessWidget {
  const _CalendarContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final LocationHistoryThemeData theme = LocationHistoryTheme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(theme.radii.medium),
      child: BackdropFilter(
        filter: theme.misc.blurFilter,
        child: AnimatedContainer(
          duration: theme.durations.short,
          decoration: BoxDecoration(
            color: theme.colors.background.withAlpha(150),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: theme.spacing.medium,
              top: theme.spacing.xSmall,
              right: theme.spacing.medium,
              bottom: theme.spacing.medium,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
