import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_calendar_state.freezed.dart';

/// {@template monthly_calendar_state}
/// Visible month focus for the monthly calendar carousel.
///
/// [focusedMonth] identifies the month page being shown; day values are ignored
/// by consumers and should be treated as month-level data.
/// {@endtemplate}
@freezed
sealed class MonthlyCalendarState with _$MonthlyCalendarState {
  /// {@macro monthly_calendar_state}
  const factory MonthlyCalendarState({required DateTime focusedMonth}) =
      _MonthlyCalendarState;
}
