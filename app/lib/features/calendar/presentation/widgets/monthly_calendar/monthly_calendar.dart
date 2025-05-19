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

/// {@template monthly_calendar}
/// A calendar widget that displays days of a specific month.
///
/// This widget shows a grid of days for a given month, determined by the
/// [monthOffset] from the currently selected month in [MonthlyCalendarCubit].
/// It includes a header for weekdays and the main grid for days.
/// User interactions (tapping on a day) are handled by [CalendarDateSelectionCubit].
///
/// The overall structure is wrapped in a [CalendarViewContainer] for consistent styling.
///
/// Sub-components:
/// - [_WeekdaysHeader]: Displays the row of weekday abbreviations (e.g., Mon, Tue).
/// - [_DaysGrid]: Displays the grid of `_DayCell` and `_WeekNumberCell` widgets.
///   - [_DayCell]: Represents a single day in the month.
///   - [_WeekNumberCell]: Displays the week number for each row of days.
/// {@endtemplate}
class MonthlyCalendar extends StatelessWidget {
  /// {@macro monthly_calendar}
  const MonthlyCalendar({super.key, required this.monthOffset});

  /// The offset from the currently selected month to display.
  /// For example, 0 means the current month, 1 means the next month, -1 means the previous month.
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
