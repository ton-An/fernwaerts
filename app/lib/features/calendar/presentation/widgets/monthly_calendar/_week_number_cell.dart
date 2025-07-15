part of 'monthly_calendar.dart';

/// {@template week_number_cell}
/// A cell that displays the week number for a row in the monthly calendar.
///
/// This widget shows the week number (1-53) for the corresponding row
/// of days in the monthly calendar grid.
/// {@endtemplate}
class _WeekNumberCell extends StatelessWidget {
  /// {@macro week_number_cell}
  const _WeekNumberCell({required this.weekNumber});

  /// The week number to display (1-53).
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
