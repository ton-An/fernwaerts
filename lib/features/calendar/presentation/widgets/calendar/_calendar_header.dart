part of 'calendar.dart';

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader();

  @override
  Widget build(BuildContext context) {
    final theme = LocationHistoryTheme.of(context);

    return BlocBuilder<MonthlyCalendarCubit, MonthlyCalendarState>(
      builder: (context, monthlyCalendarState) {
        return BlocBuilder<CalendarSelectionTypeCubit,
            CalendarSelectionTypeState>(
          builder: (context, selectionTypeState) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Switch(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onPressed: () =>
                      _onBackwardPressed(context, selectionTypeState),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      _getLabel(
                          context, selectionTypeState, monthlyCalendarState),
                      style: theme.text.title3.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                _Switch(
                  icon: Icons.arrow_forward_ios_rounded,
                  onPressed: () =>
                      _onForwardPressed(context, selectionTypeState),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _getLabel(
      BuildContext context,
      CalendarSelectionTypeState selectionTypeState,
      MonthlyCalendarState monthlyCalendarState) {
    if (selectionTypeState is CalendarRangeSelection ||
        selectionTypeState is CalendarDaySelection ||
        selectionTypeState is CalendarWeekSelection) {
      return DateFormat.yMMMM(Localizations.localeOf(context).languageCode)
          .format(monthlyCalendarState.focusedMonth);
    } else {
      return "hihi";
    }
  }

  void _onBackwardPressed(
    BuildContext context,
    CalendarSelectionTypeState selectionTypeState,
  ) {
    if (selectionTypeState is CalendarRangeSelection ||
        selectionTypeState is CalendarDaySelection ||
        selectionTypeState is CalendarWeekSelection) {
      context.read<MonthlyCalendarCubit>().showPreviousMonth();
    }
  }

  void _onForwardPressed(
    BuildContext context,
    CalendarSelectionTypeState selectionTypeState,
  ) {
    if (selectionTypeState is CalendarRangeSelection ||
        selectionTypeState is CalendarDaySelection ||
        selectionTypeState is CalendarWeekSelection) {
      context.read<MonthlyCalendarCubit>().showNextMonth();
    }
  }
}
