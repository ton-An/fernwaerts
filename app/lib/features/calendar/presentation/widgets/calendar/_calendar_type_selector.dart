part of 'calendar.dart';

/// {@template calendar_type_selector}
/// A class that represents calendar type selector.
/// {@endtemplate}
class _CalendarTypeSelector extends StatelessWidget {
/// {@macro calendar_type_selector}
  const _CalendarTypeSelector();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarSelectionTypeCubit, CalendarSelectionTypeState>(
      builder: (context, state) {
        return CustomSegmentedControl<CalendarSelectionTypeState>(
          items: [
            CustomSegmentedControlItem(
              label: AppLocalizations.of(context)!.range,
              value: const CalendarRangeSelection(),
            ),
            CustomSegmentedControlItem(
              label: AppLocalizations.of(context)!.day,
              value: const CalendarDaySelection(),
            ),
            CustomSegmentedControlItem(
              label: AppLocalizations.of(context)!.week,
              value: const CalendarWeekSelection(),
            ),
            CustomSegmentedControlItem(
              label: AppLocalizations.of(context)!.month,
              value: const CalendarMonthSelection(),
            ),
            CustomSegmentedControlItem(
              label: AppLocalizations.of(context)!.year,
              value: const CalendarYearSelection(),
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
