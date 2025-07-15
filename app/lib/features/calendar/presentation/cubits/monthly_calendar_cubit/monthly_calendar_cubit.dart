import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_date_utils/in_date_utils.dart';
import 'package:location_history/features/calendar/presentation/cubits/monthly_calendar_cubit/monthly_calendar_state.dart';

/// {@template monthly_calendar_cubit}
/// A cubit that manages monthlycalendar state.
/// {@endtemplate}
class MonthlyCalendarCubit extends Cubit<MonthlyCalendarState> {
/// {@macro monthly_calendar_cubit}
  MonthlyCalendarCubit()
    : super(MonthlyCalendarState(focusedMonth: DTU.startOfDay(DateTime.now())));

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

  void showMonth(DateTime month) {
    emit(MonthlyCalendarState(focusedMonth: DateTime(month.year, month.month)));
  }
}
