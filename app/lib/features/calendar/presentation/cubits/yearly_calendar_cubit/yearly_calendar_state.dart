import 'package:freezed_annotation/freezed_annotation.dart';

part 'yearly_calendar_state.freezed.dart';

/// {@template yearly_calendar_state}
/// Visible year focus for the yearly calendar carousel.
///
/// [focusedYear] identifies the year page being shown; month and day values are
/// ignored by consumers and should be treated as year-level data.
/// {@endtemplate}
@freezed
sealed class YearlyCalendarState with _$YearlyCalendarState {
  /// {@macro yearly_calendar_state}
  const factory YearlyCalendarState({required DateTime focusedYear}) =
      _YearlyCalendarState;
}
