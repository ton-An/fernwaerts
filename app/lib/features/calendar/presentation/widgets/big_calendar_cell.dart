import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_selection_type_cubit/calendar_selection_type_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_selection_type_cubit/calendar_selection_type_state.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

/// Visual selection states for a [BigCalendarCell].
enum BigCalendarCellType { unselected, fullySelected, partlySelected }

/// {@template big_calendar_cell}
/// A tappable cell used by the year and decade calendar views.
///
/// The cell displays a [label], applies visual selection styling from
/// [cellType], and sends [date] to [CalendarDateSelectionCubit] using the
/// current [CalendarSelectionTypeState].
///
/// The background color and text style adapt to [cellType].
/// {@endtemplate}
class BigCalendarCell extends StatelessWidget {
  /// {@macro big_calendar_cell}
  const BigCalendarCell({
    super.key,
    required this.label,
    required this.date,
    required this.cellType,
  });

  /// Text displayed in the cell, such as a month name or year.
  final String label;

  /// Date represented by this cell.
  final DateTime date;

  /// Visual selection state of the cell.
  final BigCalendarCellType cellType;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return BlocBuilder<CalendarSelectionTypeCubit, CalendarSelectionTypeState>(
      builder: (context, selectionTypeState) {
        return GestureDetector(
          onTap: () {
            context.read<CalendarDateSelectionCubit>().updateSelection(
              selectedDate: date,
              type: selectionTypeState,
            );
          },
          child: Container(
            margin: EdgeInsets.all(theme.spacing.xTiny),
            decoration: BoxDecoration(
              color: _getBackgroundColor(cellType, theme),
              borderRadius: BorderRadius.circular(theme.radii.small),
            ),
            child: Center(
              child: Text(
                label,
                style: theme.text.headline.copyWith(
                  color:
                      cellType == BigCalendarCellType.fullySelected
                          ? theme.colors.background
                          : theme.colors.text,
                  fontWeight:
                      cellType == BigCalendarCellType.fullySelected
                          ? FontWeight.w500
                          : FontWeight.w400,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getBackgroundColor(
    BigCalendarCellType cellType,
    WebfabrikThemeData theme,
  ) {
    switch (cellType) {
      case BigCalendarCellType.unselected:
        return Colors.transparent;
      case BigCalendarCellType.fullySelected:
        return theme.colors.primary;
      case BigCalendarCellType.partlySelected:
        return theme.colors.primaryTranslucent;
    }
  }
}
