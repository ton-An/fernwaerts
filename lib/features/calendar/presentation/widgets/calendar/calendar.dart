import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:location_history/core/theme/location_history_theme.dart';
import 'package:location_history/core/widgets/custom_segmented_control.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_type_cubit/calendar_type_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_type_cubit/calendar_type_state.dart';
import 'package:location_history/features/calendar/presentation/widgets/monthly_calendar/monthly_calendar.dart';
import 'package:location_history/features/calendar/presentation/widgets/multi_year_calendar/multi_year_calendar.dart';
import 'package:location_history/features/calendar/presentation/widgets/yearly_calendar/yearly_calendar.dart';

part '_calendar_container.dart';
part '_calendar_type_selector.dart';

enum CalendarSelectionType {
  customRange,
  day,
  week,
  month,
  year,
}

class Calendar extends StatelessWidget {
  const Calendar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarSelectionTypeCubit, CalendarSelectionTypeState>(
        builder: (context, selectionTypeState) {
      return _CalendarContainer(
        child: Column(
          children: [
            if (selectionTypeState is CalendarRangeSelection ||
                selectionTypeState is CalendarDaySelection ||
                selectionTypeState is CalendarWeekSelection)
              MonthlyCalendar(),
            if (selectionTypeState is CalendarMonthSelection) YearlyCalendar(),
            if (selectionTypeState is CalendarYearSelection)
              MultiYearCalendar(),
            _CalendarTypeSelector(),
          ],
        ),
      );
    });
  }
}
