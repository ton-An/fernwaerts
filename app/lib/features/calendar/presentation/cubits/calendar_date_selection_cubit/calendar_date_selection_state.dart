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

abstract class CalendarRangeSelected extends CalendarDateSelectionState {
  const CalendarRangeSelected();

  DateTime? get startDate;
  DateTime? get endDate;
}

@freezed
class CalendarCustomRangeSelected extends CalendarRangeSelected
    with _$CalendarCustomRangeSelected {
  const factory CalendarCustomRangeSelected({
    required DateTime? startDate,
    required DateTime? endDate,
  }) = _CalendarCustomRangeSelected;
}

@freezed
class CalendarWeekSelected extends CalendarRangeSelected
    with _$CalendarWeekSelected {
  const factory CalendarWeekSelected({
    required DateTime? startDate,
    required DateTime? endDate,
  }) = _CalendarWeekSelected;
}

@freezed
class CalendarMonthSelected extends CalendarRangeSelected
    with _$CalendarMonthSelected {
  const factory CalendarMonthSelected({
    required DateTime? startDate,
    required DateTime? endDate,
  }) = _CalendarMonthSelected;
}

@freezed
class CalendarYearSelected extends CalendarRangeSelected
    with _$CalendarYearSelected {
  const factory CalendarYearSelected({
    required DateTime? startDate,
    required DateTime? endDate,
  }) = _CalendarYearSelected;
}
