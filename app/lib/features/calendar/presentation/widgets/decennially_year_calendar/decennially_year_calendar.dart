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
/// Displays one decade page in the calendar carousel.
///
/// The rendered decade is the [DecenniallyCalendarCubit] focus plus
/// [decadeOffset]. Year cells delegate selection to
/// [CalendarDateSelectionCubit].
///
/// Sub-components:
/// - [_YearsGrid]: Year cells for the rendered decade.
/// {@endtemplate}
class DecenniallyYearCalendar extends StatelessWidget {
  /// {@macro decennially_year_calendar}
  const DecenniallyYearCalendar({super.key, required this.decadeOffset});

  /// Offset from the focused decade.
  ///
  /// `0` shows the focused decade, `1` the next decade, and `-1` the previous
  /// decade.
  final int decadeOffset;
  @override
  Widget build(BuildContext context) {
    return CalendarViewContainer(child: _YearsGrid(decadeOffset: decadeOffset));
  }
}
