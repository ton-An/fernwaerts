import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_date_utils/in_date_utils.dart';
import 'package:intl/intl.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_state.dart';
import 'package:location_history/features/calendar/presentation/cubits/yearly_calendar_cubit/yearly_calendar_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/yearly_calendar_cubit/yearly_calendar_state.dart';
import 'package:location_history/features/calendar/presentation/widgets/big_calendar_cell.dart';
import 'package:location_history/features/calendar/presentation/widgets/calendar_view_container.dart';

part '_months_grid.dart';

/// {@template yearly_calendar}
/// A calendar widget that displays months within a specific year.
///
/// This widget is used to show a grid of months, allowing users to select a month.
/// It relies on the [YearlyCalendarCubit] to determine the year to display
/// based on the [yearOffset] and the [CalendarDateSelectionCubit] to handle
/// month selections.
///
/// The actual layout and rendering of the months are handled by the `_MonthsGrid`
/// private widget, which is contained within a [CalendarViewContainer] for
/// consistent styling.
///
/// Sub-components:
/// - [_MonthsGrid]: Displays the grid of [BigCalendarCell] widgets for each month.
/// {@endtemplate}
class YearlyCalendar extends StatelessWidget {
  /// {@macro yearly_calendar}
  const YearlyCalendar({super.key, required this.yearOffset});

  /// The offset from the currently selected year to display.
  /// For example, 0 means the current year, 1 means the next year, -1 means the previous year.
  final int yearOffset;

  @override
  Widget build(BuildContext context) {
    return CalendarViewContainer(child: _MonthsGrid(yearOffset: yearOffset));
  }
}
