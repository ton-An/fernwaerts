import 'package:freezed_annotation/freezed_annotation.dart';

part 'yearly_calendar_state.freezed.dart';

@freezed
class YearlyCalendarState with _$YearlyCalendarState {
  const factory YearlyCalendarState({
    required DateTime focusedYear,
  }) = _YearlyCalendarState;
}
