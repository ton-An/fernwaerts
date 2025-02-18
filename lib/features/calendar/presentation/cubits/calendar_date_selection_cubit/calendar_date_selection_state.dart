import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_date_selection_state.freezed.dart';

abstract class CalendarDateSelectionState {
  const CalendarDateSelectionState();
}

@freezed
class CalendarDaySelected extends CalendarDateSelectionState
    with _$CalendarDaySelected {
  const factory CalendarDaySelected({required DateTime selectedDate}) =
      _CalendarDaySelected;
}

@freezed
class CalendarRangeSelected extends CalendarDateSelectionState
    with _$CalendarRangeSelected {
  const factory CalendarRangeSelected({
    required DateTime? startDate,
    required DateTime? endDate,
  }) = _CalendarRangeSelected;
}

@freezed
class CalendarWeekSelected extends CalendarDateSelectionState
    with _$CalendarWeekSelected {
  const factory CalendarWeekSelected({
    required DateTime? startDate,
    required DateTime? endDate,
  }) = _CalendarWeekSelected;
}

@freezed
class CalendarMonthSelected extends CalendarDateSelectionState
    with _$CalendarMonthSelected {
  const factory CalendarMonthSelected({
    required DateTime? startDate,
    required DateTime? endDate,
  }) = _CalendarMonthSelected;
}

@freezed
class CalendarYearSelected extends CalendarDateSelectionState
    with _$CalendarYearSelected {
  const factory CalendarYearSelected({
    required DateTime? startDate,
    required DateTime? endDate,
  }) = _CalendarYearSelected;
}
