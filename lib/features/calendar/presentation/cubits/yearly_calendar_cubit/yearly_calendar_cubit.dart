import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/features/calendar/presentation/cubits/yearly_calendar_cubit/yearly_calendar_state.dart';

class YearlyCalendarCubit extends Cubit<YearlyCalendarState> {
  YearlyCalendarCubit()
      : super(YearlyCalendarState(focusedYear: DateTime.now()));

  void showPreviousYear() {
    emit(
      YearlyCalendarState(
        focusedYear: DateTime(
          state.focusedYear.year - 1,
        ),
      ),
    );
  }

  void showNextYear() {
    emit(
      YearlyCalendarState(
        focusedYear: DateTime(
          state.focusedYear.year + 1,
        ),
      ),
    );
  }

  void showYearAtOffset(int offset) {
    emit(
      YearlyCalendarState(
        focusedYear: DateTime(
          state.focusedYear.year + offset,
        ),
      ),
    );
  }

  void showYear(DateTime year) {
    emit(
      YearlyCalendarState(
        focusedYear: DateTime(
          year.year,
        ),
      ),
    );
  }
}
