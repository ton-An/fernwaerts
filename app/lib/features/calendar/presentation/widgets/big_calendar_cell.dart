import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_type_cubit/calendar_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_type_cubit/calendar_selection_type_state.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

/// Defines the visual types for a [BigCalendarCell].
enum BigCalendarCellType { unselected, fullySelected, partlySelected }

/// {@template big_calendar_cell}
/// A tappable cell widget used in larger calendar views (e.g., yearly, decennially).
///
/// This widget displays a [label] (e.g., month name or year) and changes its
/// appearance based on its [cellType] (unselected, fully selected, or partly
/// selected). Tapping the cell triggers a date selection action via the
/// [CalendarDateSelectionCubit] based on the current [CalendarSelectionTypeState].
///
/// The background color and text style adapt to the [cellType] to provide
/// visual feedback on the selection state.
/// {@endtemplate}
class BigCalendarCell extends StatelessWidget {
  /// {@macro big_calendar_cell}
  const BigCalendarCell({
    super.key,
    required this.label,
    required this.date,
    required this.cellType,
  });

  /// The text to display within the cell (e.g., "Jan", "2023").
  final String label;

  /// The [DateTime] represented by this cell. Used for selection logic.
  final DateTime date;

  /// The selection type of the cell, determining its visual appearance.
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
                          ? FontWeight.w600
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
