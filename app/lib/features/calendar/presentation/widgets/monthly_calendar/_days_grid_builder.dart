part of 'monthly_calendar.dart';

/// {@template days_grid_builder}
/// Renders the actual grid of days and week numbers for a given month.
///
/// It receives pre-calculated [_DaysGridParams] and the current selection state
/// to build the UI.
/// {@endtemplate}
class _DaysGridBuilder extends StatelessWidget {
  /// {@macro days_grid_builder}
  const _DaysGridBuilder({
    required this.layoutParams,
    required this.calendarDateSelectionState,
  });

  /// Number of days in a week.
  static const int _daysInWeek = 7;

  /// Pre-calculated layout parameters for the month.
  final _DaysGridParams layoutParams;

  /// Current date selection state from the calendar.
  final CalendarDateSelectionState calendarDateSelectionState;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: layoutParams.rowCount * layoutParams.crossAxisCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: layoutParams.crossAxisCount,
      ),
      padding: EdgeInsets.zero,
      itemBuilder:
          (BuildContext context, int index) => _buildGridItem(context, index),
    );
  }

  /// Checks if the given grid [index] is the first item of a row (a week number cell).
  ///
  /// - [crossAxisCount]: Total number of columns in the grid.
  bool _isFirstItemOfRow(int index, int crossAxisCount) {
    return index % crossAxisCount == 0;
  }

  /// Calculates the week number for a given [rowNumber] in the [focusedMonth].
  ///
  /// - [startOffsetForMonth]: The 1-based weekday of the first day of the [focusedMonth].
  int _calculateWeekNumber(
    DateTime focusedMonth,
    int rowNumber,
    int startOffsetForMonth,
  ) {
    // Calculate the day index (relative to focusedMonth) of the first day cell in this row.
    // (startOffsetForMonth - 1) is the number of leading filler days.
    final int dayIndexOfFirstCellInRow =
        1 - (startOffsetForMonth - 1) + (rowNumber * _daysInWeek);

    final DateTime dateInRow = _calculateDayDate(
      dayIndexOfFirstCellInRow,
      focusedMonth,
    );
    return DTU.getWeekNumber(dateInRow);
  }

  /// Determines the [DateTime] for a given [dayInMonthIndex] relative to the [focusedMonth].
  ///
  /// The [dayInMonthIndex] can be <= 0 for days in the previous month,
  /// or > days in [focusedMonth] for days in the next month.
  /// The [DateTime] constructor handles day values outside the valid range for the month
  /// by rolling over to the previous or next month correctly.
  DateTime _calculateDayDate(int dayInMonthIndex, DateTime focusedMonth) {
    return DateTime(focusedMonth.year, focusedMonth.month, dayInMonthIndex);
  }

  /// Determines the [_DayCellType] for a given [date] based on the [selectionState],
  /// its relation to the [focusedMonth], and its position in the row.
  ///
  /// - [isFirstDayCellInRow]: True if this cell is the first day cell in its row.
  /// - [isLastDayCellInRow]: True if this cell is the last day cell in its row.
  _DayCellType _getDayCellType(
    DateTime date,
    CalendarDateSelectionState selectionState,
    DateTime focusedMonth,
    bool isFirstDayCellInRow,
    bool isLastDayCellInRow,
  ) {
    if (selectionState is CalendarDaySelected) {
      if (DTU.isSameDay(date, selectionState.selectedDate)) {
        return _DayCellType.selected;
      }
    }

    if (selectionState is CalendarRangeSelected) {
      final DateTime? startDate = selectionState.startDate;
      final DateTime? endDate = selectionState.endDate;

      final bool isLonelyRangeBoundary =
          (startDate == null &&
              endDate != null &&
              DTU.isSameDay(date, endDate)) ||
          (endDate == null &&
              startDate != null &&
              DTU.isSameDay(date, startDate));

      if (isLonelyRangeBoundary) {
        return _DayCellType.selected;
      }

      final bool isRangeStart =
          startDate != null && DTU.isSameDay(date, startDate);
      if (isRangeStart) {
        // If it's also the end date (single day range) or last cell in row for a start date
        if ((endDate != null && DTU.isSameDay(startDate, endDate)) ||
            isLastDayCellInRow) {
          return _DayCellType.selected;
        }
        return _DayCellType.rangeStart;
      }

      final bool isRangeEnd = endDate != null && DTU.isSameDay(date, endDate);
      if (isRangeEnd) {
        // If it's also the start date (single day range) or first cell in row for an end date
        if ((startDate != null && DTU.isSameDay(startDate, endDate)) ||
            isFirstDayCellInRow) {
          return _DayCellType.selected;
        }
        return _DayCellType.rangeEnd;
      }

      final bool isInRange =
          startDate != null &&
          endDate != null &&
          date.isAfter(startDate) &&
          date.isBefore(endDate);
      if (isInRange) {
        return _DayCellType.inRange;
      }
    }

    final bool isInDifferentMonth = date.month != focusedMonth.month;
    if (isInDifferentMonth) {
      return _DayCellType.filler;
    }

    return _DayCellType.unselected;
  }

  /// Calculates appropriate [BorderRadius] for a day cell that is part of a selected range,
  /// to ensure continuous highlighting with rounded corners at the edges of the selection
  /// and at row boundaries.
  ///
  /// - [rowNumber]: The 0-indexed row number of the current cell.
  /// - [totalRowCount]: Total number of rows in the grid.
  /// - [dayDate]: The date of the current cell.
  /// - [calendarDateSelectionState]: Current selection state.
  /// - [focusedMonth]: The month being displayed.
  /// - [isFirstDayCellInRow]: True if this cell is the first day cell in its row.
  /// - [isLastDayCellInRow]: True if this cell is the last day cell in its row.
  BorderRadius? _calculateInRangeBorderRadius(
    BuildContext context,
    int rowNumber,
    int totalRowCount,
    DateTime dayDate,
    CalendarDateSelectionState calendarDateSelectionState,
    DateTime focusedMonth,
    bool isFirstDayCellInRow,
    bool isLastDayCellInRow,
  ) {
    BorderRadius? inRangeBorderRadius;

    // Only apply special border radius if the cell is at the start or end of a row.
    if (isFirstDayCellInRow || isLastDayCellInRow) {
      final bool isFirstRowInGrid = rowNumber == 0;
      final bool isLastRowInGrid = rowNumber == totalRowCount - 1;

      // Determine type of cell directly above.
      _DayCellType? cellTypeAbove;
      if (!isFirstRowInGrid) {
        cellTypeAbove = _getDayCellType(
          dayDate.subtract(const Duration(days: _daysInWeek)),
          calendarDateSelectionState,
          focusedMonth,
          isFirstDayCellInRow, // Use current cell's row position flags for neighbors
          isLastDayCellInRow,
        );
      }

      // Determine type of cell directly below.
      _DayCellType? cellTypeBelow;
      if (!isLastRowInGrid) {
        cellTypeBelow = _getDayCellType(
          dayDate.add(const Duration(days: _daysInWeek)),
          calendarDateSelectionState,
          focusedMonth,
          isFirstDayCellInRow, // Use current cell's row position flags for neighbors
          isLastDayCellInRow,
        );
      }

      final bool isCellAbovePartOfRange =
          cellTypeAbove == _DayCellType.inRange ||
          cellTypeAbove == _DayCellType.rangeStart ||
          cellTypeAbove == _DayCellType.rangeEnd ||
          cellTypeAbove == _DayCellType.selected;

      final bool isCellBelowPartOfRange =
          cellTypeBelow == _DayCellType.inRange ||
          cellTypeBelow == _DayCellType.rangeStart ||
          cellTypeBelow == _DayCellType.rangeEnd ||
          cellTypeBelow == _DayCellType.selected;

      final bool shouldRoundTop = isFirstRowInGrid || !isCellAbovePartOfRange;
      final bool shouldRoundBottom = isLastRowInGrid || !isCellBelowPartOfRange;

      if (shouldRoundTop || shouldRoundBottom) {
        final double borderRadiusValue = WebfabrikTheme.of(context).radii.small;
        inRangeBorderRadius = BorderRadius.only(
          topLeft:
              shouldRoundTop && isFirstDayCellInRow
                  ? Radius.circular(borderRadiusValue)
                  : Radius.zero,
          topRight:
              shouldRoundTop && isLastDayCellInRow
                  ? Radius.circular(borderRadiusValue)
                  : Radius.zero,
          bottomLeft:
              shouldRoundBottom && isFirstDayCellInRow
                  ? Radius.circular(borderRadiusValue)
                  : Radius.zero,
          bottomRight:
              shouldRoundBottom && isLastDayCellInRow
                  ? Radius.circular(borderRadiusValue)
                  : Radius.zero,
        );
      }
    }
    return inRangeBorderRadius;
  }

  /// Builds a single grid item, which can be a week number cell or a day cell.
  Widget _buildGridItem(BuildContext context, int index) {
    final int rowNumber = index ~/ layoutParams.crossAxisCount;

    if (_isFirstItemOfRow(index, layoutParams.crossAxisCount)) {
      return _WeekNumberCell(
        weekNumber: _calculateWeekNumber(
          layoutParams.focusedMonth,
          rowNumber,
          layoutParams.startOffsetForMonth,
        ),
      );
    }

    // This dayInMonthIndex is relative to the start of layoutParams.focusedMonth.
    final int dayInMonthIndex =
        index - rowNumber - layoutParams.startOffsetForMonth + 1;

    final DateTime dayDate = _calculateDayDate(
      dayInMonthIndex,
      layoutParams.focusedMonth,
    );

    // Determine if the cell is the first or last day cell in its visual row.
    final int columnPositionInRow = index % layoutParams.crossAxisCount;
    final bool isFirstDayCellInRow = columnPositionInRow == 1;
    final bool isLastDayCellInRow = columnPositionInRow == _daysInWeek;

    final _DayCellType cellType = _getDayCellType(
      dayDate,
      calendarDateSelectionState,
      layoutParams.focusedMonth,
      isFirstDayCellInRow,
      isLastDayCellInRow,
    );

    BorderRadius? inRangeBorderRadius;
    if (cellType == _DayCellType.inRange) {
      inRangeBorderRadius = _calculateInRangeBorderRadius(
        context,
        rowNumber,
        layoutParams.rowCount,
        dayDate,
        calendarDateSelectionState,
        layoutParams.focusedMonth,
        isFirstDayCellInRow,
        isLastDayCellInRow,
      );
    }

    return _DayCell(
      date: dayDate,
      type: cellType,
      inRangeBorderRadius: inRangeBorderRadius,
    );
  }
}
