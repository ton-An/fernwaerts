import 'package:freezed_annotation/freezed_annotation.dart';

part 'decennially_calendar_state.freezed.dart';

/// {@template decennially_calendar_state}
/// Visible decade range for the decade calendar carousel.
///
/// [startYear] and [endYear] are inclusive year boundaries for the rendered year
/// grid.
/// {@endtemplate}
@freezed
sealed class DecenniallyCalendarState with _$DecenniallyCalendarState {
  /// {@macro decennially_calendar_state}
  const factory DecenniallyCalendarState({
    required DateTime startYear,
    required DateTime endYear,
  }) = _DecenniallyCalendarState;
}
