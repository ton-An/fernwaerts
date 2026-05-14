import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_selection_type_state.freezed.dart';

/// {@template calendar_selection_type_state}
/// Base state for the active calendar selection granularity.
/// {@endtemplate}
abstract class CalendarSelectionTypeState {
  /// {@macro calendar_selection_type_state}
  const CalendarSelectionTypeState();
}

/// {@template calendar_day_selection}
/// Calendar mode for selecting individual days.
/// {@endtemplate}
@freezed
sealed class CalendarDaySelection extends CalendarSelectionTypeState
    with _$CalendarDaySelection {
  /// {@macro calendar_day_selection}
  const factory CalendarDaySelection() = _CalendarDaySelection;

  const CalendarDaySelection._();
}

/// {@template calendar_range_selection}
/// Calendar mode for selecting custom date ranges.
/// {@endtemplate}
@freezed
sealed class CalendarRangeSelection extends CalendarSelectionTypeState
    with _$CalendarRangeSelection {
  /// {@macro calendar_range_selection}
  const factory CalendarRangeSelection() = _CalendarRangeSelection;

  const CalendarRangeSelection._();
}

/// {@template calendar_week_selection}
/// Calendar mode for selecting complete Monday-through-Sunday weeks.
/// {@endtemplate}
@freezed
sealed class CalendarWeekSelection extends CalendarSelectionTypeState
    with _$CalendarWeekSelection {
  /// {@macro calendar_week_selection}
  const factory CalendarWeekSelection() = _CalendarWeekSelection;

  const CalendarWeekSelection._();
}

/// {@template calendar_month_selection}
/// Calendar mode for selecting complete months.
/// {@endtemplate}
@freezed
sealed class CalendarMonthSelection extends CalendarSelectionTypeState
    with _$CalendarMonthSelection {
  /// {@macro calendar_month_selection}
  const factory CalendarMonthSelection() = _CalendarMonthSelection;

  const CalendarMonthSelection._();
}

/// {@template calendar_year_selection}
/// Calendar mode for selecting complete years.
/// {@endtemplate}
@freezed
sealed class CalendarYearSelection extends CalendarSelectionTypeState
    with _$CalendarYearSelection {
  /// {@macro calendar_year_selection}
  const factory CalendarYearSelection() = _CalendarYearSelection;

  const CalendarYearSelection._();
}
