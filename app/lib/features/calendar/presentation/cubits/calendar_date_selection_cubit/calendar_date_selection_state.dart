import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_date_selection_state.freezed.dart';

abstract class CalendarDateSelectionState {
  const CalendarDateSelectionState();
}

@freezed
sealed class CalendarDaySelected extends CalendarDateSelectionState
    with _$CalendarDaySelected {
  const factory CalendarDaySelected({required DateTime selectedDate}) =
      _CalendarDaySelected;

  const CalendarDaySelected._();
}

abstract class CalendarRangeSelected extends CalendarDateSelectionState {
  const CalendarRangeSelected();

  DateTime? get startDate;
  DateTime? get endDate;
}

@freezed
sealed class CalendarCustomRangeSelected extends CalendarRangeSelected
    with _$CalendarCustomRangeSelected {
  const factory CalendarCustomRangeSelected({
    required DateTime? startDate,
    required DateTime? endDate,
  }) = _CalendarCustomRangeSelected;

  const CalendarCustomRangeSelected._();
}

@freezed
sealed class CalendarWeekSelected extends CalendarRangeSelected
    with _$CalendarWeekSelected {
  const factory CalendarWeekSelected({
    required DateTime? startDate,
    required DateTime? endDate,
  }) = _CalendarWeekSelected;

  const CalendarWeekSelected._();
}

@freezed
sealed class CalendarMonthSelected extends CalendarRangeSelected
    with _$CalendarMonthSelected {
  const factory CalendarMonthSelected({
    required DateTime? startDate,
    required DateTime? endDate,
  }) = _CalendarMonthSelected;

  const CalendarMonthSelected._();
}

@freezed
sealed class CalendarYearSelected extends CalendarRangeSelected
    with _$CalendarYearSelected {
  const factory CalendarYearSelected({
    required DateTime? startDate,
    required DateTime? endDate,
  }) = _CalendarYearSelected;

  const CalendarYearSelected._();
}
