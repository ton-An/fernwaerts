part of 'monthly_calendar.dart';

/// {@template days_grid}
/// A widget that calculates layout parameters for a month's grid and then delegates
/// rendering to [_DaysGridBuilder].
/// {@endtemplate}
class _DaysGrid extends StatelessWidget {
  /// {@macro days_grid}
  const _DaysGrid({required this.monthOffset});

  /// Number of days in a week.
  static const int _daysInWeek = 7;

  /// Numeric representation of the first day in a month.
  static const int _firstDayOfMonthNumber = 1;

  /// Month offset to apply relative to the globally focused month.
  final int monthOffset;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarDateSelectionCubit, CalendarDateSelectionState>(
      builder: (context, calendarDateSelectionState) {
        return BlocBuilder<MonthlyCalendarCubit, MonthlyCalendarState>(
          builder: (context, monthlyCalendarState) {
            final _DaysGridParams layoutParams = _calculateMonthLayoutParams(
              monthlyCalendarState.focusedMonth,
              monthOffset,
            );

            return _DaysGridBuilder(
              layoutParams: layoutParams,
              calendarDateSelectionState: calendarDateSelectionState,
            );
          },
        );
      },
    );
  }

  /// Calculates the layout parameters for the month grid.
  ///
  /// - [baseFocusedMonth]: The reference month from the calendar's global state.
  /// - [monthOffsetInput]: The offset to apply to the [baseFocusedMonth].
  ///
  /// Returns [_DaysGridParams] containing all necessary values for rendering.
  _DaysGridParams _calculateMonthLayoutParams(
    DateTime baseFocusedMonth,
    int monthOffsetInput,
  ) {
    final DateTime focusedMonth = DTU.addMonths(
      baseFocusedMonth,
      monthOffsetInput,
    );
    final DateTime firstDayOfMonth = DateTime(
      focusedMonth.year,
      focusedMonth.month,
      _firstDayOfMonthNumber,
    );

    // Determine the 1-based weekday (1=Monday, ..., 7=Sunday) for the 1st of the month.
    final int startOffsetForMonth = firstDayOfMonth.weekday;

    final int daysInFocusedMonth =
        DateTime(focusedMonth.year, focusedMonth.month + 1, 0).day;

    // Number of filler cells from the previous month shown at the start of the grid.
    final int leadingFillerCount = startOffsetForMonth - 1;

    // Total cells occupied by leading fillers and the actual days of the focused month.
    final int cellsForMonthAndLeadingFillers =
        leadingFillerCount + daysInFocusedMonth;

    // Number of filler cells from the next month shown at the end of the grid
    // to complete the last week.
    final int trailingFillerCount =
        (_daysInWeek - (cellsForMonthAndLeadingFillers % _daysInWeek)) %
        _daysInWeek;

    // Total number of day cells that will be displayed in the grid.
    final int totalDayCellsToDisplay =
        cellsForMonthAndLeadingFillers + trailingFillerCount;

    // Number of rows in the grid.
    final int rowCount = totalDayCellsToDisplay ~/ _daysInWeek;

    const int crossAxisCount = _daysInWeek + 1; // days + 1 for week number

    return _DaysGridParams(
      focusedMonth: focusedMonth,
      startOffsetForMonth: startOffsetForMonth,
      daysInFocusedMonth: daysInFocusedMonth,
      leadingFillerCount: leadingFillerCount,
      totalDayCellsToDisplay: totalDayCellsToDisplay,
      rowCount: rowCount,
      crossAxisCount: crossAxisCount,
    );
  }
}
