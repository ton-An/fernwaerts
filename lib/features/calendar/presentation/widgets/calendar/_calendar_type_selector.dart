part of 'calendar.dart';

class _CalendarTypeSelector extends StatelessWidget {
  const _CalendarTypeSelector();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarSelectionTypeCubit, CalendarSelectionTypeState>(
      builder: (context, state) {
        return CustomSegmentedControl<CalendarSelectionTypeState>(
          items: [
            CustomSegmentedControlItem(
              label: AppLocalizations.of(context)!.range,
              value: CalendarRangeSelection(),
            ),
            CustomSegmentedControlItem(
              label: AppLocalizations.of(context)!.day,
              value: CalendarDaySelection(),
            ),
            CustomSegmentedControlItem(
              label: AppLocalizations.of(context)!.week,
              value: CalendarWeekSelection(),
            ),
            CustomSegmentedControlItem(
              label: AppLocalizations.of(context)!.month,
              value: CalendarMonthSelection(),
            ),
            CustomSegmentedControlItem(
              label: AppLocalizations.of(context)!.year,
              value: CalendarYearSelection(),
            ),
          ],
          selectedValue: state,
          onChanged: (CalendarSelectionTypeState selectionTypeState) {
            context.read<CalendarSelectionTypeCubit>().changeType(
              selectionTypeState,
            );
          },
        );
      },
    );
  }
}
