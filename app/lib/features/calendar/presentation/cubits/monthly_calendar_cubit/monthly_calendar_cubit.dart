import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/features/calendar/presentation/cubits/monthly_calendar_cubit/monthly_calendar_state.dart';

class MonthlyCalendarCubit extends Cubit<MonthlyCalendarState> {
  MonthlyCalendarCubit()
    : super(MonthlyCalendarState(focusedMonth: DateTime.now()));

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
