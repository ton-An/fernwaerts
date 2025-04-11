import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_calendar_state.freezed.dart';

@freezed
sealed class MonthlyCalendarState with _$MonthlyCalendarState {
  const factory MonthlyCalendarState({required DateTime focusedMonth}) =
      _MonthlyCalendarState;
}
