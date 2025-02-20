part of 'decennially_year_calendar.dart';

class _YearsGrid extends StatelessWidget {
  const _YearsGrid({
    required this.decadeOffset,
  });

  final int decadeOffset;

  static const _yearsInDecade = 10;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarDateSelectionCubit, CalendarDateSelectionState>(
      builder: (context, calendarDateSelectionState) {
        return BlocBuilder<DecenniallyCalendarCubit, DecenniallyCalendarState>(
          builder: (context, decenniallyCalendarState) {
            final DateTime focusedDecadeStart = DTU.addYears(
                decenniallyCalendarState.startYear,
                decadeOffset * _yearsInDecade);

            return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _yearsInDecade,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 3),
                itemBuilder: (context, index) {
                  final DateTime yearDate =
                      DTU.addYears(focusedDecadeStart, index);

                  final BigCalendarCellType cellType = _getYearCellType(
                    yearDate,
                    calendarDateSelectionState,
                  );

                  return BigCalendarCell(
                    label: DateFormat.y(
                            Localizations.localeOf(context).languageCode)
                        .format(yearDate),
                    date: yearDate,
                    cellType: cellType,
                  );
                });
          },
        );
      },
    );
  }

  BigCalendarCellType _getYearCellType(
    DateTime yearDate,
    CalendarDateSelectionState calendarDateSelectionState,
  ) {
    if (calendarDateSelectionState is CalendarDaySelected) {
      if (calendarDateSelectionState.selectedDate.year == yearDate.year) {
        return BigCalendarCellType.partlySelected;
      }
    }

    if (calendarDateSelectionState is CalendarRangeSelected) {
      final DateTime startOfYear = DTU.firstDayOfYear(yearDate);
      final DateTime endOfYear = DTU.lastDayOfYear(yearDate);

      if (_isYearFullySelected(
          startOfYear, endOfYear, calendarDateSelectionState)) {
        return BigCalendarCellType.fullySelected;
      }

      if (_isStartDateInYear(yearDate, calendarDateSelectionState)) {
        return BigCalendarCellType.partlySelected;
      } else if (_isEndDateInYearAndStartUnselected(
          yearDate, calendarDateSelectionState)) {
        return BigCalendarCellType.partlySelected;
      }
    }

    return BigCalendarCellType.unselected;
  }

  bool _isYearFullySelected(DateTime startOfYear, DateTime endOfYear,
      CalendarRangeSelected calendarRangeSelectedState) {
    return calendarRangeSelectedState.startDate != null &&
        calendarRangeSelectedState.endDate != null &&
        calendarRangeSelectedState.startDate!.day == startOfYear.day &&
        calendarRangeSelectedState.startDate!.month == startOfYear.month &&
        calendarRangeSelectedState.startDate!.year == startOfYear.year &&
        calendarRangeSelectedState.endDate!.day == endOfYear.day &&
        calendarRangeSelectedState.endDate!.month == endOfYear.month &&
        calendarRangeSelectedState.endDate!.year == endOfYear.year;
  }

  bool _isStartDateInYear(
      DateTime monthDate, CalendarRangeSelected calendarRangeSelectedState) {
    return calendarRangeSelectedState.startDate != null &&
        calendarRangeSelectedState.startDate!.year == monthDate.year;
  }

  bool _isEndDateInYearAndStartUnselected(
      DateTime monthDate, CalendarRangeSelected calendarRangeSelectedState) {
    return calendarRangeSelectedState.endDate == null &&
        calendarRangeSelectedState.endDate != null &&
        calendarRangeSelectedState.endDate!.year == monthDate.year;
  }
}
