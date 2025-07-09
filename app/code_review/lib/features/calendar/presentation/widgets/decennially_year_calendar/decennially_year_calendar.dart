import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_date_utils/in_date_utils.dart';
import 'package:intl/intl.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_state.dart';
import 'package:location_history/features/calendar/presentation/cubits/decennially_calendar_cubit/decennially_calendar_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/decennially_calendar_cubit/decennially_calendar_state.dart';
import 'package:location_history/features/calendar/presentation/widgets/big_calendar_cell.dart';
import 'package:location_history/features/calendar/presentation/widgets/calendar_view_container.dart';

part '_years_grid.dart';

/// {@template decennially_year_calendar}
/// A calendar widget that displays years within a specific decade.
///
/// This widget is used to show a grid of years, allowing users to select a year.
/// It relies on the [DecenniallyCalendarCubit] to determine the decade to display
/// based on the [decadeOffset] and the [CalendarDateSelectionCubit] to handle
/// year selections.
///
/// The actual layout and rendering of the years are handled by the `_YearsGrid`
/// private widget, which is contained within a [CalendarViewContainer] for
/// consistent styling.
///
/// Sub-components:
/// - [_YearsGrid]: Displays the grid of [BigCalendarCell] widgets for each year.
/// {@endtemplate}
class DecenniallyYearCalendar extends StatelessWidget {
  /// {@macro decennially_year_calendar}
  const DecenniallyYearCalendar({super.key, required this.decadeOffset});

  /// The offset from the currently selected decade to display.
  /// For example, 0 means the current decade, 1 means the next decade, -1 means the previous decade.
  final int decadeOffset;
  @override
  Widget build(BuildContext context) {
    return CalendarViewContainer(child: _YearsGrid(decadeOffset: decadeOffset));
  }
}
