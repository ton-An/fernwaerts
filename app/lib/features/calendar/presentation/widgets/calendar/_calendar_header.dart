part of 'calendar.dart';

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader();

  @override
  Widget build(BuildContext context) {
    final theme = WebfabrikTheme.of(context);

    return BlocBuilder<DecenniallyCalendarCubit, DecenniallyCalendarState>(
      builder: (context, decenniallyCalendarState) {
        return BlocBuilder<YearlyCalendarCubit, YearlyCalendarState>(
          builder: (context, yearlyCalendarState) {
            return BlocBuilder<MonthlyCalendarCubit, MonthlyCalendarState>(
              builder: (context, monthlyCalendarState) {
                return BlocBuilder<
                  CalendarSelectionTypeCubit,
                  CalendarSelectionTypeState
                >(
                  builder: (context, selectionTypeState) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _Switch(
                          icon: Icons.arrow_back_ios_new_rounded,
                          onPressed:
                              () => _onBackwardPressed(
                                context,
                                selectionTypeState,
                              ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              _getLabel(
                                context,
                                selectionTypeState,
                                monthlyCalendarState,
                                yearlyCalendarState,
                                decenniallyCalendarState,
                              ),
                              style: theme.text.title3.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        _Switch(
                          icon: Icons.arrow_forward_ios_rounded,
                          onPressed:
                              () => _onForwardPressed(
                                context,
                                selectionTypeState,
                              ),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  String _getLabel(
    BuildContext context,
    CalendarSelectionTypeState selectionTypeState,
    MonthlyCalendarState monthlyCalendarState,
    YearlyCalendarState yearlyCalendarState,
    DecenniallyCalendarState decenniallyCalendarState,
  ) {
    if (selectionTypeState is CalendarRangeSelection ||
        selectionTypeState is CalendarDaySelection ||
        selectionTypeState is CalendarWeekSelection) {
      return DateFormat.yMMMM(
        Localizations.localeOf(context).languageCode,
      ).format(monthlyCalendarState.focusedMonth);
    } else if (selectionTypeState is CalendarMonthSelection) {
      return DateFormat.y(
        Localizations.localeOf(context).languageCode,
      ).format(yearlyCalendarState.focusedYear);
    } else if (selectionTypeState is CalendarYearSelection) {
      return "${DateFormat("y", Localizations.localeOf(context).languageCode).format(decenniallyCalendarState.startYear)} - ${DateFormat("y", Localizations.localeOf(context).languageCode).format(decenniallyCalendarState.endYear)}";
    } else {
      return "hoooops :)";
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

    if (selectionTypeState is CalendarMonthSelection) {
      context.read<YearlyCalendarCubit>().showPreviousYear();
    }

    if (selectionTypeState is CalendarYearSelection) {
      context.read<DecenniallyCalendarCubit>().showPreviousDecade();
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

    if (selectionTypeState is CalendarMonthSelection) {
      context.read<YearlyCalendarCubit>().showNextYear();
    }

    if (selectionTypeState is CalendarYearSelection) {
      context.read<DecenniallyCalendarCubit>().showNextDecade();
    }
  }
}
