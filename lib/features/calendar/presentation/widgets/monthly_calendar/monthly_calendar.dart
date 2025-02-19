import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_date_utils/in_date_utils.dart';
import 'package:intl/intl.dart';
import 'package:location_history/core/theme/location_history_theme.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_state.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_type_cubit/calendar_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_type_cubit/calendar_selection_type_state.dart';
import 'package:location_history/features/calendar/presentation/cubits/monthly_calendar_cubit/monthly_calendar_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/monthly_calendar_cubit/monthly_calendar_state.dart';

part '_day_cell.dart';
part '_days_grid.dart';
part '_week_number_cell.dart';
part '_weekdays_header.dart';

class MonthlyCalendar extends StatelessWidget {
  const MonthlyCalendar({
    super.key,
    required this.monthOffset,
  });

  final int monthOffset;

  @override
  Widget build(BuildContext context) {
    final LocationHistoryThemeData theme = LocationHistoryTheme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: theme.spacing.small,
        top: theme.spacing.xSmall,
        right: theme.spacing.xSmall,
        bottom: theme.spacing.small,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          LocationHistoryTheme.of(context).radii.medium,
        ),
        color: theme.colors.translucentBackground,
      ),
      child: Column(
        children: [
          _WeekdaysHeader(),
          _DaysGrid(monthOffset: monthOffset),
        ],
      ),
    );
  }
}
