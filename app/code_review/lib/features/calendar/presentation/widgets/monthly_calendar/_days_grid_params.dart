part of 'monthly_calendar.dart';

/// {@template days_grid_params}
/// Holds pre-calculated layout parameters for rendering a month's grid.
/// {@endtemplate}
class _DaysGridParams {
  /// {@macro days_grid_params}
  const _DaysGridParams({
    required this.focusedMonth,
    required this.startOffsetForMonth,
    required this.daysInFocusedMonth,
    required this.leadingFillerCount,
    required this.totalDayCellsToDisplay,
    required this.rowCount,
    required this.crossAxisCount,
  });

  /// The specific month this layout is for (already adjusted by monthOffset).
  final DateTime focusedMonth;

  /// The 1-based weekday (1=Monday, ..., 7=Sunday) of the first day of the [focusedMonth].
  /// This determines the column where the month's first day appears.
  final int startOffsetForMonth;

  /// The total number of days in the [focusedMonth].
  final int daysInFocusedMonth;

  /// Number of filler day cells displayed from the previous month.
  final int leadingFillerCount;

  /// Total number of day cells displayed in the grid (leading fillers + month days + trailing fillers).
  /// This will be a multiple of `_daysInWeek`.
  final int totalDayCellsToDisplay;

  /// Number of rows in the calendar grid.
  final int rowCount;

  /// Number of columns in the GridView (days in a week + 1 for week number).
  final int crossAxisCount;
}
