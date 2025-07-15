import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_date_utils/in_date_utils.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_state.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_type_cubit/calendar_selection_type_state.dart';
import 'package:location_history/features/calendar/presentation/widgets/calendar_composite/calendar_composite.dart';

/// {@template calendar_date_selection_cubit}
/// A cubit that manages calendardateselection state.
/// {@endtemplate}
class CalendarDateSelectionCubit extends Cubit<CalendarDateSelectionState> {
/// {@macro calendar_date_selection_cubit}
  CalendarDateSelectionCubit()
    : super(CalendarDaySelected(selectedDate: DTU.startOfDay(DateTime.now())));

  bool _hasShiftedSelection = false;

  /// Indicates if the selection has been shifted. This information
  /// is needed to decide if the calendar view needs to be updated
  /// when the [CalendarComposite] gets expanded
  bool get hasShiftedSelection => _hasShiftedSelection;

  /// Resets the shifted selection flag.
  ///
  /// Used to track when a selection has been programmatically shifted
  /// rather than directly selected by a user.
  void resetHasShiftedSelection() {
    _hasShiftedSelection = false;
  }

  /// Updates the calendar selection based on the provided date and selection type.
  ///
  /// Parameters:
  /// - [selectedDate]: The date to select.
  /// - [type]: The type of selection (day, range, week, month, year).
  ///
  /// Emits:
  /// - [CalendarDaySelected] when a day is selected.
  /// - [CalendarCustomRangeSelected] when a range is selected.
  /// - [CalendarWeekSelected] when a week is selected.
  /// - [CalendarMonthSelected] when a month is selected.
  /// - [CalendarYearSelected] when a year is selected.
  void updateSelection({
    required DateTime selectedDate,
    required CalendarSelectionTypeState type,
  }) {
    if (type is CalendarDaySelection) {
      _selectDay(selectedDate: selectedDate);
    } else if (type is CalendarRangeSelection) {
      _selectRange(selectedDate: selectedDate);
    } else if (type is CalendarWeekSelection) {
      _selectWeek(selectedDate: selectedDate);
    } else if (type is CalendarMonthSelection) {
      _selectMonth(selectedDate: selectedDate);
    } else if (type is CalendarYearSelection) {
      _selectYear(selectedDate: selectedDate);
    }
  }

  /// Shifts the current selection forward or backward in time.
  ///
  /// This method maintains the current selection pattern (day, range, week, etc.)
  /// while moving it in the specified direction.
  ///
  /// Parameters:
  /// - [forward]: When true, shifts the selection forward in time.
  ///   When false, shifts the selection backward in time.
  ///
  /// Emits:
  /// - [CalendarDaySelected] when a day is selected.
  /// - [CalendarCustomRangeSelected] when a range is selected.
  /// - [CalendarWeekSelected] when a week is selected.
  /// - [CalendarMonthSelected] when a month is selected.
  /// - [CalendarYearSelected] when a year is selected.
  void shiftSelection({required bool forward}) {
    _hasShiftedSelection = true;

    if (state is CalendarDaySelected) {
      _shiftDay(
        selectedDate: (state as CalendarDaySelected).selectedDate,
        forward: forward,
      );
    } else if (state is CalendarRangeSelected) {
      _shiftRange(forward: forward);
    }
  }

  void _shiftRange({required bool forward}) {
    final DateTime? startDate = (state as CalendarRangeSelected).startDate;
    final DateTime? endDate = (state as CalendarRangeSelected).endDate;

    if (startDate == null && endDate == null) {
      return;
    }

    if (startDate == null && endDate != null ||
        startDate != null && endDate == null) {
      final DateTime toBeShiftedDate = startDate ?? endDate!;
      _shiftDay(selectedDate: toBeShiftedDate, forward: forward);
    }

    if (state is CalendarCustomRangeSelected) {
      _shiftCustomRange(
        startDate: startDate!,
        endDate: endDate!,
        forward: forward,
      );
    } else if (state is CalendarWeekSelected) {
      _shiftWeek(startDate: startDate!, endDate: endDate!, forward: forward);
    } else if (state is CalendarMonthSelected) {
      _shiftMonth(startDate: startDate!, endDate: endDate!, forward: forward);
    } else if (state is CalendarYearSelected) {
      _shiftYear(startDate: startDate!, endDate: endDate!, forward: forward);
    }
  }

  DateTime _addMonthsToRangeEnd(DateTime date, int months) {
    final DateTime newMonth = DateUtils.addMonthsToMonthDate(date, months);
    final DateTime newDate = DTU.lastDayOfMonth(newMonth);

    return newDate;
  }

  void _shiftCustomRange({
    required DateTime startDate,
    required DateTime endDate,
    required bool forward,
  }) {
    final Duration dateDifference = endDate.difference(startDate);
    final DateTime shiftedStartDate =
        forward
            ? startDate.add(dateDifference)
            : startDate.subtract(dateDifference);
    final DateTime shiftedEndDate =
        forward
            ? endDate.add(dateDifference)
            : endDate.subtract(dateDifference);

    emit(
      CalendarCustomRangeSelected(
        startDate: shiftedStartDate,
        endDate: shiftedEndDate,
      ),
    );
  }

  void _shiftWeek({
    required DateTime startDate,
    required DateTime endDate,
    required bool forward,
  }) {
    final DateTime shiftedStartDate =
        forward ? DTU.addWeeks(startDate, 1) : DTU.addWeeks(startDate, -1);
    final DateTime shiftedEndDate =
        forward ? DTU.addWeeks(endDate, 1) : DTU.addWeeks(endDate, -1);

    emit(
      CalendarWeekSelected(
        startDate: shiftedStartDate,
        endDate: shiftedEndDate,
      ),
    );
  }

  void _shiftMonth({
    required DateTime startDate,
    required DateTime endDate,
    required bool forward,
  }) {
    final DateTime shiftedStartDate =
        forward ? DTU.addMonths(startDate, 1) : DTU.addMonths(startDate, -1);

    final DateTime shiftedEndDate =
        forward
            ? _addMonthsToRangeEnd(endDate, 1)
            : _addMonthsToRangeEnd(endDate, -1);

    emit(
      CalendarMonthSelected(
        startDate: shiftedStartDate,
        endDate: shiftedEndDate,
      ),
    );
  }

  void _shiftYear({
    required DateTime startDate,
    required DateTime endDate,
    required bool forward,
  }) {
    final DateTime shiftedStartDate =
        forward ? DTU.addYears(startDate, 1) : DTU.addYears(startDate, -1);
    final DateTime shiftedEndDate =
        forward ? DTU.addYears(endDate, 1) : DTU.addYears(endDate, -1);

    emit(
      CalendarYearSelected(
        startDate: shiftedStartDate,
        endDate: shiftedEndDate,
      ),
    );
  }

  void _shiftDay({required DateTime selectedDate, required bool forward}) {
    const Duration durationOfDay = Duration(days: 1);
    final DateTime shiftedDay =
        forward
            ? selectedDate.add(durationOfDay)
            : selectedDate.subtract(durationOfDay);
    emit(CalendarDaySelected(selectedDate: shiftedDay));
  }

  void _selectDay({required DateTime selectedDate}) {
    emit(CalendarDaySelected(selectedDate: selectedDate));
  }

  void _selectRange({required DateTime selectedDate}) {
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

  void _selectWeek({required DateTime selectedDate}) {
    final DateTime startOfWeek = selectedDate.subtract(
      Duration(days: selectedDate.weekday - 1),
    );
    final DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

    emit(CalendarWeekSelected(startDate: startOfWeek, endDate: endOfWeek));
  }

  void _selectMonth({required DateTime selectedDate}) {
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

  void _selectYear({required DateTime selectedDate}) {
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
