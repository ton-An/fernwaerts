part of 'yearly_calendar.dart';

/// {@template months_grid}
/// A grid widget that displays months of a year in a yearly calendar view.
///
/// This widget renders a grid of month cells, allowing users to select
/// specific months within a year.
/// {@endtemplate}
class _MonthsGrid extends StatelessWidget {
  /// {@macro months_grid}
  const _MonthsGrid({required this.yearOffset});

  /// The offset from the currently selected year to display.
  final int yearOffset;

  static const _monthsInYear = 12;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarDateSelectionCubit, CalendarDateSelectionState>(
      builder: (context, calendarDateSelectionState) {
        return BlocBuilder<YearlyCalendarCubit, YearlyCalendarState>(
          builder: (context, yearlyCalendarState) {
            final DateTime focusedYear = DTU.addYears(
              yearlyCalendarState.focusedYear,
              yearOffset,
            );

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _monthsInYear,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3,
              ),
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final DateTime monthDate = DateTime(
                  focusedYear.year,
                  index + 1,
                );

                final BigCalendarCellType cellType = _getMonthCellType(
                  monthDate,
                  calendarDateSelectionState,
                );

                return BigCalendarCell(
                  label: DateFormat.MMMM(
                    Localizations.localeOf(context).languageCode,
                  ).format(monthDate),
                  date: monthDate,
                  cellType: cellType,
                );
              },
            );
          },
        );
      },
    );
  }

  BigCalendarCellType _getMonthCellType(
    DateTime monthDate,
    CalendarDateSelectionState calendarDateSelectionState,
  ) {
    if (calendarDateSelectionState is CalendarDaySelected) {
      if (calendarDateSelectionState.selectedDate.month == monthDate.month &&
          calendarDateSelectionState.selectedDate.year == monthDate.year) {
        return BigCalendarCellType.partlySelected;
      }
    }

    if (calendarDateSelectionState is CalendarRangeSelected) {
      final DateTime startOfMonth = DTU.firstDayOfMonth(monthDate);
      final DateTime endOfMonth = DTU.lastDayOfMonth(monthDate);

      if (_isMonthFullySelected(
        startOfMonth,
        endOfMonth,
        calendarDateSelectionState,
      )) {
        return BigCalendarCellType.fullySelected;
      }

      if (_isStartDateInMonth(monthDate, calendarDateSelectionState)) {
        return BigCalendarCellType.partlySelected;
      } else if (_isEndDateInMonthAndStartUnselected(
        monthDate,
        calendarDateSelectionState,
      )) {
        return BigCalendarCellType.partlySelected;
      }
    }

    return BigCalendarCellType.unselected;
  }

  bool _isMonthFullySelected(
    DateTime startOfMonth,
    DateTime endOfMonth,
    CalendarRangeSelected calendarRangeSelectedState,
  ) {
    return calendarRangeSelectedState.startDate != null &&
        calendarRangeSelectedState.endDate != null &&
        calendarRangeSelectedState.startDate!.day == startOfMonth.day &&
        calendarRangeSelectedState.startDate!.month == startOfMonth.month &&
        calendarRangeSelectedState.startDate!.year == startOfMonth.year &&
        calendarRangeSelectedState.endDate!.day == endOfMonth.day &&
        calendarRangeSelectedState.endDate!.month == endOfMonth.month &&
        calendarRangeSelectedState.endDate!.year == endOfMonth.year;
  }

  bool _isStartDateInMonth(
    DateTime monthDate,
    CalendarRangeSelected calendarRangeSelectedState,
  ) {
    return calendarRangeSelectedState.startDate != null &&
        calendarRangeSelectedState.startDate!.month == monthDate.month &&
        calendarRangeSelectedState.startDate!.year == monthDate.year;
  }

  bool _isEndDateInMonthAndStartUnselected(
    DateTime monthDate,
    CalendarRangeSelected calendarRangeSelectedState,
  ) {
    return calendarRangeSelectedState.startDate == null &&
        calendarRangeSelectedState.endDate != null &&
        calendarRangeSelectedState.endDate!.month == monthDate.month &&
        calendarRangeSelectedState.endDate!.year == monthDate.year;
  }
}
