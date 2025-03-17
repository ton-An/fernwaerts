import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_type_cubit/calendar_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_type_cubit/calendar_selection_type_state.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

enum BigCalendarCellType { unselected, fullySelected, partlySelected }

class BigCalendarCell extends StatelessWidget {
  const BigCalendarCell({
    super.key,
    required this.label,
    required this.date,
    required this.cellType,
  });

  final String label;
  final DateTime date;
  final BigCalendarCellType cellType;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return BlocBuilder<CalendarSelectionTypeCubit, CalendarSelectionTypeState>(
      builder: (context, selectionTypeState) {
        return GestureDetector(
          onTap: () {
            context.read<CalendarDateSelectionCubit>().selectDate(
              date,
              selectionTypeState,
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
