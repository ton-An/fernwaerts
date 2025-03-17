import 'package:freezed_annotation/freezed_annotation.dart';

part 'decennially_calendar_state.freezed.dart';

@freezed
class DecenniallyCalendarState with _$DecenniallyCalendarState {
  const factory DecenniallyCalendarState({
    required DateTime startYear,
    required DateTime endYear,
  }) = _DecenniallyCalendarState;
}
