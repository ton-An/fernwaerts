import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_selection_type_state.freezed.dart';

abstract class CalendarSelectionTypeState {
  const CalendarSelectionTypeState();
}

@freezed
class CalendarDaySelection extends CalendarSelectionTypeState
    with _$CalendarDaySelection {
  const factory CalendarDaySelection() = _CalendarDaySelection;
}

@freezed
class CalendarRangeSelection extends CalendarSelectionTypeState
    with _$CalendarRangeSelection {
  const factory CalendarRangeSelection() = _CalendarRangeSelection;
}

@freezed
class CalendarWeekSelection extends CalendarSelectionTypeState
    with _$CalendarWeekSelection {
  const factory CalendarWeekSelection() = _CalendarWeekSelection;
}

@freezed
class CalendarMonthSelection extends CalendarSelectionTypeState
    with _$CalendarMonthSelection {
  const factory CalendarMonthSelection() = _CalendarMonthSelection;
}

@freezed
class CalendarYearSelection extends CalendarSelectionTypeState
    with _$CalendarYearSelection {
  const factory CalendarYearSelection() = _CalendarYearSelection;
}
