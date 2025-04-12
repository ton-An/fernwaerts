import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_date_utils/in_date_utils.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_state.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_type_cubit/calendar_selection_type_state.dart';

class CalendarDateSelectionCubit extends Cubit<CalendarDateSelectionState> {
  CalendarDateSelectionCubit()
    : super(CalendarDaySelected(selectedDate: DTU.startOfDay(DateTime.now())));

  bool hasMovedRange = false;

  void resetHasMovedRange() {
    hasMovedRange = false;
  }

  void moveRange({required bool isForward}) {
    hasMovedRange = true;
    if (state is CalendarDaySelected) {
      _moveDaySelection((state as CalendarDaySelected).selectedDate, isForward);
    } else if (state is CalendarRangeSelected) {
      final DateTime? startDate = (state as CalendarRangeSelected).startDate;
      final DateTime? endDate = (state as CalendarRangeSelected).endDate;

      if (startDate == null && endDate == null) {
        return;
      }

      if (startDate == null && endDate != null ||
          startDate != null && endDate == null) {
        final DateTime toBeMovedDate = startDate ?? endDate!;
        _moveDaySelection(toBeMovedDate, isForward);
      }

      late DateTime movedStartDate;
      late DateTime movedEndDate;

      if (state is CalendarCustomRangeSelected) {
        final Duration dateDifference = endDate!.difference(startDate!);
        movedStartDate =
            isForward
                ? startDate.add(dateDifference)
                : startDate.subtract(dateDifference);
        movedEndDate =
            isForward
                ? endDate.add(dateDifference)
                : endDate.subtract(dateDifference);
        emit(
          CalendarCustomRangeSelected(
            startDate: movedStartDate,
            endDate: movedEndDate,
          ),
        );
      } else if (state is CalendarWeekSelected) {
        movedStartDate =
            isForward
                ? DTU.addWeeks(startDate!, 1)
                : DTU.addWeeks(startDate!, -1);
        movedEndDate =
            isForward ? DTU.addWeeks(endDate!, 1) : DTU.addWeeks(endDate!, -1);

        emit(
          CalendarWeekSelected(
            startDate: movedStartDate,
            endDate: movedEndDate,
          ),
        );
      } else if (state is CalendarMonthSelected) {
        movedStartDate =
            isForward
                ? DTU.addMonths(startDate!, 1)
                : DTU.addMonths(startDate!, -1);

        movedEndDate =
            isForward
                ? _addMonthsToRangeEnd(endDate!, 1)
                : _addMonthsToRangeEnd(endDate!, -1);

        emit(
          CalendarMonthSelected(
            startDate: movedStartDate,
            endDate: movedEndDate,
          ),
        );
      } else if (state is CalendarYearSelected) {
        movedStartDate =
            isForward
                ? DTU.addYears(startDate!, 1)
                : DTU.addYears(startDate!, -1);
        movedEndDate =
            isForward ? DTU.addYears(endDate!, 1) : DTU.addYears(endDate!, -1);

        emit(
          CalendarYearSelected(
            startDate: movedStartDate,
            endDate: movedEndDate,
          ),
        );
      }
    }
  }

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

  DateTime _addMonthsToRangeEnd(DateTime date, int months) {
    final DateTime newMonth = DateUtils.addMonthsToMonthDate(date, months);
    final DateTime newDate = DTU.lastDayOfMonth(newMonth);

    return newDate;
  }

  void _moveDaySelection(DateTime selectedDate, bool isForward) {
    const Duration durationOfDay = Duration(days: 1);
    final DateTime movedDate =
        isForward
            ? selectedDate.add(durationOfDay)
            : selectedDate.subtract(durationOfDay);
    emit(CalendarDaySelected(selectedDate: movedDate));
  }

  void _selectDay(DateTime selectedDate) {
    emit(CalendarDaySelected(selectedDate: selectedDate));
  }

  void _selectRange(DateTime selectedDate) {
    if (state is! CalendarCustomRangeSelected) {
      emit(CalendarCustomRangeSelected(startDate: selectedDate, endDate: null));
      return;
    }

    final CalendarCustomRangeSelected currentRange =
        state as CalendarCustomRangeSelected;

    if (_isDateAlreadySelected(selectedDate, currentRange)) return;

    if (currentRange.startDate == null) {
      emit(
        CalendarCustomRangeSelected(
          startDate: selectedDate,
          endDate: currentRange.endDate,
        ),
      );
    }

    if (selectedDate.isBefore(currentRange.startDate!)) {
      emit(
        CalendarCustomRangeSelected(
          startDate: selectedDate,
          endDate: currentRange.startDate,
        ),
      );
    } else if (currentRange.endDate == null ||
        selectedDate.isAfter(currentRange.endDate!)) {
      emit(
        CalendarCustomRangeSelected(
          startDate: currentRange.startDate,
          endDate: selectedDate,
        ),
      );
    } else {
      emit(CalendarCustomRangeSelected(startDate: selectedDate, endDate: null));
    }
  }

  void _selectWeek(DateTime selectedDate) {
    final DateTime startOfWeek = selectedDate.subtract(
      Duration(days: selectedDate.weekday - 1),
    );
    final DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

    emit(CalendarWeekSelected(startDate: startOfWeek, endDate: endOfWeek));
  }

  void _selectMonth(DateTime selectedDate) {
    final DateTime startOfMonth = DateTime(
      selectedDate.year,
      selectedDate.month,
    );
    final DateTime endOfMonth = DateTime(
      selectedDate.year,
      selectedDate.month + 1,
    ).subtract(const Duration(days: 1));

    emit(CalendarMonthSelected(startDate: startOfMonth, endDate: endOfMonth));
  }

  void _selectYear(DateTime selectedDate) {
    final DateTime startOfYear = DateTime(selectedDate.year);
    final DateTime endOfYear = DateTime(
      selectedDate.year + 1,
    ).subtract(const Duration(days: 1));

    emit(CalendarYearSelected(startDate: startOfYear, endDate: endOfYear));
  }

  bool _isDateAlreadySelected(
    DateTime date,
    CalendarCustomRangeSelected range,
  ) {
    return (range.startDate != null &&
            date.isAtSameMomentAs(range.startDate!)) ||
        (range.endDate != null && date.isAtSameMomentAs(range.endDate!));
  }
}
