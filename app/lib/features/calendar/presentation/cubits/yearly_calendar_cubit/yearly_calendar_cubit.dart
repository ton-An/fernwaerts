import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/features/calendar/presentation/cubits/yearly_calendar_cubit/yearly_calendar_state.dart';

/// {@template yearly_calendar_cubit}
/// Tracks the year currently focused by yearly calendar views.
///
/// This Cubit controls the visible year page in the calendar carousel.
/// {@endtemplate}
class YearlyCalendarCubit extends Cubit<YearlyCalendarState> {
  /// {@macro yearly_calendar_cubit}
  YearlyCalendarCubit()
    : super(YearlyCalendarState(focusedYear: DateTime.now()));

  /// Moves the focused year one year backward.
  void showPreviousYear() {
    emit(
      YearlyCalendarState(focusedYear: DateTime(state.focusedYear.year - 1)),
    );
  }

  /// Moves the focused year one year forward.
  void showNextYear() {
    emit(
      YearlyCalendarState(focusedYear: DateTime(state.focusedYear.year + 1)),
    );
  }

  /// Moves the focused year by [offset] years from the current focus.
  void showYearAtOffset(int offset) {
    emit(
      YearlyCalendarState(
        focusedYear: DateTime(state.focusedYear.year + offset),
      ),
    );
  }

  /// Focuses the year containing [year].
  void showYear(DateTime year) {
    emit(YearlyCalendarState(focusedYear: DateTime(year.year)));
  }
}
