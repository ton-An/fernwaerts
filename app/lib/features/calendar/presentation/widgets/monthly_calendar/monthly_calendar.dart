import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_date_utils/in_date_utils.dart';
import 'package:intl/intl.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_state.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_type_cubit/calendar_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_type_cubit/calendar_selection_type_state.dart';
import 'package:location_history/features/calendar/presentation/cubits/monthly_calendar_cubit/monthly_calendar_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/monthly_calendar_cubit/monthly_calendar_state.dart';
import 'package:location_history/features/calendar/presentation/widgets/calendar_view_container.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

part '_day_cell.dart';
part '_days_grid.dart';
part '_week_number_cell.dart';
part '_weekdays_header.dart';

class MonthlyCalendar extends StatelessWidget {
  const MonthlyCalendar({super.key, required this.monthOffset});

  final int monthOffset;

  @override
  Widget build(BuildContext context) {
    return CalendarViewContainer(
      child: Column(
        children: [
          const _WeekdaysHeader(),
          _DaysGrid(monthOffset: monthOffset),
        ],
      ),
    );
  }
}
