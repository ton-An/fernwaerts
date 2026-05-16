import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_date_utils/in_date_utils.dart';
import 'package:location_history/features/calendar/presentation/cubits/monthly_calendar_cubit/monthly_calendar_state.dart';

/// {@template monthly_calendar_cubit}
/// Tracks the month currently focused by monthly calendar views.
///
/// This Cubit controls the visible month page in the calendar carousel.
/// {@endtemplate}
class MonthlyCalendarCubit extends Cubit<MonthlyCalendarState> {
  /// {@macro monthly_calendar_cubit}
  MonthlyCalendarCubit()
    : super(MonthlyCalendarState(focusedMonth: DTU.startOfDay(DateTime.now())));

  /// Moves the focused month one month backward.
  void showPreviousMonth() {
    emit(
      MonthlyCalendarState(
        focusedMonth: DateTime(
          state.focusedMonth.year,
          state.focusedMonth.month - 1,
        ),
      ),
    );
  }

  /// Moves the focused month one month forward.
  void showNextMonth() {
    emit(
      MonthlyCalendarState(
        focusedMonth: DateTime(
          state.focusedMonth.year,
          state.focusedMonth.month + 1,
        ),
      ),
    );
  }

  /// Moves the focused month by [offset] months from the current focus.
  void showMonthAtOffset(int offset) {
    emit(
      MonthlyCalendarState(
        focusedMonth: DateTime(
          state.focusedMonth.year,
          state.focusedMonth.month + offset,
        ),
      ),
    );
  }

  /// Focuses the month containing [month].
  void showMonth(DateTime month) {
    emit(MonthlyCalendarState(focusedMonth: DateTime(month.year, month.month)));
  }
}
