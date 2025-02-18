import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_state.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_type_cubit/calendar_selection_type_state.dart';

class CalendarDateSelectionCubit extends Cubit<CalendarDateSelectionState> {
  CalendarDateSelectionCubit()
      : super(CalendarDaySelected(selectedDate: DateTime.now()));

  void selectDate(DateTime selectedDate, CalendarSelectionTypeState type) {
    if (type is CalendarDaySelection) {
      _selectDay(selectedDate);
    } else if (type is CalendarRangeSelection) {
      _selectRange(selectedDate);
    } else if (type is CalendarWeekSelection) {
      _selectWeek(selectedDate);
    } else if (type is CalendarMonthSelection) {
      _selectMonth(selectedDate);
    } else if (type is CalendarYearSelection) {
      _selectYear(selectedDate);
    }
  }

  void _selectDay(DateTime selectedDate) {
    emit(CalendarDaySelected(selectedDate: selectedDate));
  }

  void _selectRange(DateTime selectedDate) {
    if (state is! CalendarRangeSelected) {
      emit(CalendarRangeSelected(startDate: selectedDate, endDate: null));
      return;
    }

    final CalendarRangeSelected currentRange = state as CalendarRangeSelected;

    if (_isDateAlreadySelected(selectedDate, currentRange)) return;

    if (currentRange.startDate == null) {
      emit(
        CalendarRangeSelected(
          startDate: selectedDate,
          endDate: currentRange.endDate,
        ),
      );
    }

    if (selectedDate.isBefore(currentRange.startDate!)) {
      emit(
        CalendarRangeSelected(
          startDate: selectedDate,
          endDate: currentRange.startDate,
        ),
      );
    }

    if (currentRange.endDate == null ||
        selectedDate.isAfter(currentRange.endDate!)) {
      emit(
        CalendarRangeSelected(
          startDate: currentRange.startDate,
          endDate: selectedDate,
        ),
      );
    }

    emit(
      CalendarRangeSelected(
        startDate: selectedDate,
        endDate: null,
      ),
    );
  }

  void _selectWeek(DateTime selectedDate) {
    final DateTime startOfWeek =
        selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    final DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

    emit(
      CalendarWeekSelected(
        startDate: startOfWeek,
        endDate: endOfWeek,
      ),
    );
  }

  void _selectMonth(DateTime selectedDate) {
    final DateTime startOfMonth =
        DateTime(selectedDate.year, selectedDate.month);
    final DateTime endOfMonth =
        DateTime(selectedDate.year, selectedDate.month + 1)
            .subtract(Duration(days: 1));

    emit(
      CalendarMonthSelected(
        startDate: startOfMonth,
        endDate: endOfMonth,
      ),
    );
  }

  void _selectYear(DateTime selectedDate) {
    final DateTime startOfYear = DateTime(selectedDate.year);
    final DateTime endOfYear =
        DateTime(selectedDate.year + 1).subtract(Duration(days: 1));

    emit(
      CalendarYearSelected(
        startDate: startOfYear,
        endDate: endOfYear,
      ),
    );
  }

  bool _isDateAlreadySelected(DateTime date, CalendarRangeSelected range) {
    return (range.startDate != null &&
            date.isAtSameMomentAs(range.startDate!)) ||
        (range.endDate != null && date.isAtSameMomentAs(range.endDate!));
  }
}
