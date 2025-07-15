part of 'calendar.dart';

/// {@template calendar_container}
/// A container widget that wraps calendar content.
/// {@endtemplate}
class _CalendarContainer extends StatelessWidget {
/// {@macro calendar_container}
  const _CalendarContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);
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
              top: theme.spacing.xSmall,
              bottom: theme.spacing.medium,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
