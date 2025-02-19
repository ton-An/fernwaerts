part of 'monthly_calendar.dart';

class _DaysGrid extends StatelessWidget {
  const _DaysGrid({
    required this.monthOffset,
  });

  final int monthOffset;

  static const int _daysInWeek = 7;
  static const int _firstDayOfMonthNumber = 1;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarDateSelectionCubit, CalendarDateSelectionState>(
      builder: (context, calendarDateSelectionState) {
        return BlocBuilder<MonthlyCalendarCubit, MonthlyCalendarState>(
          builder: (context, monthlyCalendarState) {
            final DateTime focusedMonth =
                DTU.addMonths(monthlyCalendarState.focusedMonth, monthOffset);
            final DateTime firstDayOfMonth = DateTime(
                focusedMonth.year, focusedMonth.month, _firstDayOfMonthNumber);
            int startOffset = firstDayOfMonth.weekday % _daysInWeek;
            startOffset = startOffset == 0 ? 7 : startOffset;
            final int daysInMonth =
                DateTime(focusedMonth.year, focusedMonth.month + 1, 0).day;
            int endOffset =
                ((daysInMonth + startOffset) % _daysInWeek - 7).abs();
            endOffset = endOffset == 6 ? -1 : endOffset;
            endOffset = endOffset == 7 ? 0 : endOffset;
            final int totalDays = daysInMonth + startOffset + endOffset;
            final int rowCount = (totalDays / _daysInWeek).ceil();
            final int crossAxisCount = _daysInWeek + 1;

            return GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: totalDays + rowCount,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
              ),
              itemBuilder: (BuildContext context, int index) {
                final int rowNumber = index ~/ crossAxisCount;

                if (_isFirstItemOfRow(index)) {
                  return _WeekNumberCell(
                    weekNumber:
                        _calculateWeekNumber(focusedMonth, index, rowNumber),
                  );
                }

                final int dayInMonthIndex = index - rowNumber - startOffset + 1;

                final DateTime dayDate = _calculateDayDate(
                  dayInMonthIndex,
                  focusedMonth,
                );

                final _DayCellType cellType = _getDayCellType(
                  dayDate,
                  calendarDateSelectionState,
                  focusedMonth,
                );

                return _DayCell(
                  date: dayDate,
                  type: cellType,
                );
              },
            );
          },
        );
      },
    );
  }

  bool _isFirstItemOfRow(int index) {
    return index % (_daysInWeek + 1) == 0;
  }

  int _calculateWeekNumber(DateTime focusedMonth, int index, int rowNumber) {
    final DateTime firstDayOfWeek = DateTime(
      focusedMonth.year,
      focusedMonth.month,
      rowNumber * _daysInWeek + 1,
    );
    final int weekNumber = DTU.getWeekNumber(firstDayOfWeek);

    return weekNumber;
  }

  DateTime _calculateDayDate(
    int dayInMonthIndex,
    DateTime focusedMonth,
  ) {
    if (dayInMonthIndex <= 0) {
      final int dayNumber =
          DateTime(focusedMonth.year, focusedMonth.month, 0).day +
              dayInMonthIndex;
      final int monthNumber = focusedMonth.month - 1;
      return focusedMonth.copyWith(month: monthNumber, day: dayNumber);
    }

    if (dayInMonthIndex >
        DateTime(focusedMonth.year, focusedMonth.month + 1, 0).day) {
      final int monthNumber = focusedMonth.month + 1;
      final int dayNumber =
          dayInMonthIndex - DateTime(focusedMonth.year, monthNumber, 0).day;

      return focusedMonth.copyWith(month: monthNumber, day: dayNumber);
    }

    return focusedMonth.copyWith(day: dayInMonthIndex);
  }

  // filler dates should also be selectable
  _DayCellType _getDayCellType(
    DateTime date,
    CalendarDateSelectionState selectionState,
    DateTime focusedMonth,
  ) {
    if (selectionState is CalendarDaySelected) {
      if (date == selectionState.selectedDate) {
        return _DayCellType.selected;
      }
    }

    if (selectionState is CalendarRangeSelected) {
      if (selectionState.startDate == null && date == selectionState.endDate ||
          selectionState.endDate == null && date == selectionState.startDate) {
        return _DayCellType.selected;
      }

      if (date == selectionState.startDate) {
        return _DayCellType.rangeStart;
      }

      if (date == selectionState.endDate) {
        return _DayCellType.rangeEnd;
      }

      if (selectionState.startDate != null &&
          selectionState.endDate != null &&
          date.isAfter(selectionState.startDate!) &&
          date.isBefore(selectionState.endDate!)) {
        return _DayCellType.inRange;
      }
    }

    if (date.month != focusedMonth.month) {
      return _DayCellType.filler;
    }

    return _DayCellType.unselected;
  }
}
