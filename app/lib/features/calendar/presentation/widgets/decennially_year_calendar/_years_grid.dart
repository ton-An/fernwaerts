part of 'decennially_year_calendar.dart';

class _YearsGrid extends StatelessWidget {
  const _YearsGrid({required this.decadeOffset});

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
              decadeOffset * _yearsInDecade,
            );

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _yearsInDecade,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3,
              ),
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final DateTime yearDate = DTU.addYears(
                  focusedDecadeStart,
                  index,
                );

                final BigCalendarCellType cellType = _getYearCellType(
                  yearDate,
                  calendarDateSelectionState,
                );

                return BigCalendarCell(
                  label: DateFormat.y(
                    Localizations.localeOf(context).languageCode,
                  ).format(yearDate),
                  date: yearDate,
                  cellType: cellType,
                );
              },
            );
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

      if (_endAndStartInYear(
        startOfYear,
        endOfYear,
        calendarDateSelectionState,
      )) {
        return BigCalendarCellType.partlySelected;
      }

      if (_isStartDateInYear(yearDate, calendarDateSelectionState)) {
        return BigCalendarCellType.fullySelected;
      } else if (_isEndDateInYear(yearDate, calendarDateSelectionState)) {
        return BigCalendarCellType.fullySelected;
      } else if (_isEndDateInYearAndStartUnselected(
        yearDate,
        calendarDateSelectionState,
      )) {
        return BigCalendarCellType.fullySelected;
      }

      if (_isYearFullySelected(
        startOfYear,
        endOfYear,
        calendarDateSelectionState,
      )) {
        return BigCalendarCellType.partlySelected;
      }
    }

    return BigCalendarCellType.unselected;
  }

  bool _endAndStartInYear(
    DateTime startOfYear,
    DateTime endOfYear,
    CalendarRangeSelected calendarRangeSelectedState,
  ) {
    return calendarRangeSelectedState.startDate != null &&
            calendarRangeSelectedState.endDate != null &&
            (calendarRangeSelectedState.startDate!.isAfter(startOfYear) &&
                calendarRangeSelectedState.endDate!.isBefore(endOfYear)) ||
        (calendarRangeSelectedState.startDate!.isAfter(startOfYear) &&
            calendarRangeSelectedState.endDate!.isAtSameMomentAs(endOfYear)) ||
        (calendarRangeSelectedState.startDate!.isAtSameMomentAs(startOfYear) &&
            calendarRangeSelectedState.endDate!.isBefore(endOfYear));
  }

  bool _isYearFullySelected(
    DateTime startOfYear,
    DateTime endOfYear,
    CalendarRangeSelected calendarRangeSelectedState,
  ) {
    return calendarRangeSelectedState.startDate != null &&
        calendarRangeSelectedState.endDate != null &&
        (calendarRangeSelectedState.startDate!.isBefore(startOfYear) ||
            calendarRangeSelectedState.startDate!.isAtSameMomentAs(
              startOfYear,
            )) &&
        (calendarRangeSelectedState.endDate!.isAfter(endOfYear) ||
            calendarRangeSelectedState.endDate!.isAtSameMomentAs(endOfYear));
  }

  bool _isStartDateInYear(
    DateTime yearDate,
    CalendarRangeSelected calendarRangeSelectedState,
  ) {
    return calendarRangeSelectedState.startDate != null &&
        calendarRangeSelectedState.startDate!.year == yearDate.year;
  }

  bool _isEndDateInYear(
    DateTime yearDate,
    CalendarRangeSelected calendarRangeSelectedState,
  ) {
    return calendarRangeSelectedState.endDate != null &&
        calendarRangeSelectedState.endDate!.year == yearDate.year;
  }

  bool _isEndDateInYearAndStartUnselected(
    DateTime yearDate,
    CalendarRangeSelected calendarRangeSelectedState,
  ) {
    return calendarRangeSelectedState.startDate == null &&
        calendarRangeSelectedState.endDate != null &&
        calendarRangeSelectedState.endDate!.year == yearDate.year;
  }
}
