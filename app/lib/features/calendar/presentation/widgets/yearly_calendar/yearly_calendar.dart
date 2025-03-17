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

class YearlyCalendar extends StatelessWidget {
  const YearlyCalendar({super.key, required this.yearOffset});

  final int yearOffset;

  @override
  Widget build(BuildContext context) {
    return CalendarViewContainer(child: _MonthsGrid(yearOffset: yearOffset));
  }
}
