part of 'monthly_calendar.dart';

class _WeekNumberCell extends StatelessWidget {
  const _WeekNumberCell({
    required this.weekNumber,
  });

  final int weekNumber;

  @override
  Widget build(BuildContext context) {
    final theme = WebfabrikTheme.of(context);

    return Center(
      child: Text(
        weekNumber.toString(),
        style: theme.text.footnote.copyWith(
          color: theme.colors.text.withValues(alpha: .5),
        ),
      ),
    );
  }
}
