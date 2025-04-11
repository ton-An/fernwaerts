import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_selection_type_state.freezed.dart';

abstract class CalendarSelectionTypeState {
  const CalendarSelectionTypeState();
}

@freezed
sealed class CalendarDaySelection extends CalendarSelectionTypeState
    with _$CalendarDaySelection {
  const factory CalendarDaySelection() = _CalendarDaySelection;

  const CalendarDaySelection._();
}

@freezed
sealed class CalendarRangeSelection extends CalendarSelectionTypeState
    with _$CalendarRangeSelection {
  const factory CalendarRangeSelection() = _CalendarRangeSelection;

  const CalendarRangeSelection._();
}

@freezed
sealed class CalendarWeekSelection extends CalendarSelectionTypeState
    with _$CalendarWeekSelection {
  const factory CalendarWeekSelection() = _CalendarWeekSelection;

  const CalendarWeekSelection._();
}

@freezed
sealed class CalendarMonthSelection extends CalendarSelectionTypeState
    with _$CalendarMonthSelection {
  const factory CalendarMonthSelection() = _CalendarMonthSelection;

  const CalendarMonthSelection._();
}

@freezed
sealed class CalendarYearSelection extends CalendarSelectionTypeState
    with _$CalendarYearSelection {
  const factory CalendarYearSelection() = _CalendarYearSelection;

  const CalendarYearSelection._();
}
