import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_date_selection_state.freezed.dart';

/// {@template calendar_date_selection_state}
/// Base state for the date or date range selected in the calendar UI.
/// {@endtemplate}
abstract class CalendarDateSelectionState {
  /// {@macro calendar_date_selection_state}
  const CalendarDateSelectionState();
}

/// {@template calendar_day_selected}
/// A single selected calendar day.
/// {@endtemplate}
@freezed
sealed class CalendarDaySelected extends CalendarDateSelectionState
    with _$CalendarDaySelected {
  /// {@macro calendar_day_selected}
  const factory CalendarDaySelected({required DateTime selectedDate}) =
      _CalendarDaySelected;

  const CalendarDaySelected._();
}

/// {@template calendar_range_selected}
/// Base state for selections represented by optional start and end dates.
///
/// Range-building interactions can temporarily emit only one boundary while the
/// user is choosing the second date.
/// {@endtemplate}
abstract class CalendarRangeSelected extends CalendarDateSelectionState {
  /// {@macro calendar_range_selected}
  const CalendarRangeSelected();

  DateTime? get startDate;
  DateTime? get endDate;
}

/// {@template calendar_custom_range_selected}
/// A user-defined date range that may be complete or partially selected.
/// {@endtemplate}
@freezed
sealed class CalendarCustomRangeSelected extends CalendarRangeSelected
    with _$CalendarCustomRangeSelected {
  /// {@macro calendar_custom_range_selected}
  const factory CalendarCustomRangeSelected({
    required DateTime? startDate,
    required DateTime? endDate,
  }) = _CalendarCustomRangeSelected;

  const CalendarCustomRangeSelected._();
}

/// {@template calendar_week_selected}
/// A selected Monday-through-Sunday week.
/// {@endtemplate}
@freezed
sealed class CalendarWeekSelected extends CalendarRangeSelected
    with _$CalendarWeekSelected {
  /// {@macro calendar_week_selected}
  const factory CalendarWeekSelected({
    required DateTime? startDate,
    required DateTime? endDate,
  }) = _CalendarWeekSelected;

  const CalendarWeekSelected._();
}

/// {@template calendar_month_selected}
/// A selected complete calendar month.
/// {@endtemplate}
@freezed
sealed class CalendarMonthSelected extends CalendarRangeSelected
    with _$CalendarMonthSelected {
  /// {@macro calendar_month_selected}
  const factory CalendarMonthSelected({
    required DateTime? startDate,
    required DateTime? endDate,
  }) = _CalendarMonthSelected;

  const CalendarMonthSelected._();
}

/// {@template calendar_year_selected}
/// A selected complete calendar year.
/// {@endtemplate}
@freezed
sealed class CalendarYearSelected extends CalendarRangeSelected
    with _$CalendarYearSelected {
  /// {@macro calendar_year_selected}
  const factory CalendarYearSelected({
    required DateTime? startDate,
    required DateTime? endDate,
  }) = _CalendarYearSelected;

  const CalendarYearSelected._();
}
