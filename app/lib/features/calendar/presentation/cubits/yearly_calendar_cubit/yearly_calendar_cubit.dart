import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/features/calendar/presentation/cubits/yearly_calendar_cubit/yearly_calendar_state.dart';

/// {@template yearly_calendar_cubit}
/// A cubit that manages yearlycalendar state.
/// {@endtemplate}
class YearlyCalendarCubit extends Cubit<YearlyCalendarState> {
/// {@macro yearly_calendar_cubit}
  YearlyCalendarCubit()
    : super(YearlyCalendarState(focusedYear: DateTime.now()));

  void showPreviousYear() {
    emit(
      YearlyCalendarState(focusedYear: DateTime(state.focusedYear.year - 1)),
    );
  }

  void showNextYear() {
    emit(
      YearlyCalendarState(focusedYear: DateTime(state.focusedYear.year + 1)),
    );
  }

  void showYearAtOffset(int offset) {
    emit(
      YearlyCalendarState(
        focusedYear: DateTime(state.focusedYear.year + offset),
      ),
    );
  }

  void showYear(DateTime year) {
    emit(YearlyCalendarState(focusedYear: DateTime(year.year)));
  }
}
