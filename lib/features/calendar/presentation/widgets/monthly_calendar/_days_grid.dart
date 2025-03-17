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

                final bool isFirstDayCellInRow =
                    (index - rowNumber) % _daysInWeek == 1;
                final bool isLastDayCellInRow =
                    (index - rowNumber) % _daysInWeek == 0;

                final _DayCellType cellType = _getDayCellType(
                  dayDate,
                  calendarDateSelectionState,
                  focusedMonth,
                  isFirstDayCellInRow,
                  isLastDayCellInRow,
                );

                BorderRadius? inRangeBorderRadius;

                if (cellType == _DayCellType.inRange) {
                  inRangeBorderRadius = _calculateInRangeBorderRadius(
                      context,
                      index,
                      rowNumber,
                      rowCount,
                      dayDate,
                      calendarDateSelectionState,
                      focusedMonth,
                      isFirstDayCellInRow,
                      isLastDayCellInRow);
                }

                return _DayCell(
                  date: dayDate,
                  type: cellType,
                  inRangeBorderRadius: inRangeBorderRadius,
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
    final bool isDateInPreviousMonth = dayInMonthIndex <= 0;

    if (isDateInPreviousMonth) {
      final int dayNumber =
          DateTime(focusedMonth.year, focusedMonth.month, 0).day +
              dayInMonthIndex;
      final int monthNumber = focusedMonth.month - 1;
      return focusedMonth.copyWith(month: monthNumber, day: dayNumber);
    }

    final bool isDateInNextMonth = dayInMonthIndex >
        DateTime(focusedMonth.year, focusedMonth.month + 1, 0).day;

    if (isDateInNextMonth) {
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
    bool isFirstDayCellInRow,
    bool isLastDayCellInRow,
  ) {
    if (selectionState is CalendarDaySelected) {
      if (date == selectionState.selectedDate) {
        return _DayCellType.selected;
      }
    }

    if (selectionState is CalendarRangeSelected) {
      final bool isLonelyRangeBoundary = selectionState.startDate == null &&
              date == selectionState.endDate ||
          selectionState.endDate == null && date == selectionState.startDate;

      if (isLonelyRangeBoundary) {
        return _DayCellType.selected;
      }

      final bool isRangeStart = date == selectionState.startDate;
      if (isRangeStart) {
        if (isLastDayCellInRow) {
          return _DayCellType.selected;
        }
        return _DayCellType.rangeStart;
      }

      final bool isRangeEnd = date == selectionState.endDate;
      if (isRangeEnd) {
        if (isFirstDayCellInRow) {
          return _DayCellType.selected;
        }
        return _DayCellType.rangeEnd;
      }

      final bool isInRange = selectionState.startDate != null &&
          selectionState.endDate != null &&
          date.isAfter(selectionState.startDate!) &&
          date.isBefore(selectionState.endDate!);
      if (isInRange) {
        return _DayCellType.inRange;
      }
    }

    bool isInDifferentMonth = date.month != focusedMonth.month;
    if (isInDifferentMonth) {
      return _DayCellType.filler;
    }

    return _DayCellType.unselected;
  }

  BorderRadius? _calculateInRangeBorderRadius(
    BuildContext context,
    int index,
    int rowNumber,
    int rowCount,
    DateTime dayDate,
    CalendarDateSelectionState calendarDateSelectionState,
    DateTime focusedMonth,
    bool isFirstDayCellInRow,
    bool isLastDayCellInRow,
  ) {
    BorderRadius? inRangeBorderRadius;

    if (isFirstDayCellInRow || isLastDayCellInRow) {
      final bool isFirstRow = rowNumber == 0;
      final bool isLastRow = rowNumber == rowCount - 1;
      final _DayCellType? cellTypeAbove = isFirstRow
          ? null
          : _getDayCellType(
              dayDate.subtract(Duration(days: _daysInWeek)),
              calendarDateSelectionState,
              focusedMonth,
              isFirstDayCellInRow,
              isLastDayCellInRow,
            );
      final _DayCellType? cellTypeBelow = isLastRow
          ? null
          : _getDayCellType(
              dayDate.add(Duration(days: _daysInWeek)),
              calendarDateSelectionState,
              focusedMonth,
              isFirstDayCellInRow,
              isLastDayCellInRow,
            );

      final bool isCellAboveInRange = cellTypeAbove == _DayCellType.inRange;
      final bool isCellBelowInRange = cellTypeBelow == _DayCellType.inRange;
      if (!isCellAboveInRange || !isCellBelowInRange) {
        final double borderRadius = WebfabrikTheme.of(context).radii.small;
        inRangeBorderRadius = BorderRadius.only(
          topLeft: !isCellAboveInRange && isFirstDayCellInRow
              ? Radius.circular(borderRadius)
              : Radius.zero,
          topRight: !isCellAboveInRange && isLastDayCellInRow
              ? Radius.circular(borderRadius)
              : Radius.zero,
          bottomLeft: !isCellBelowInRange && isFirstDayCellInRow
              ? Radius.circular(borderRadius)
              : Radius.zero,
          bottomRight: !isCellBelowInRange && isLastDayCellInRow
              ? Radius.circular(borderRadius)
              : Radius.zero,
        );
      }
    }
    return inRangeBorderRadius;
  }
}
