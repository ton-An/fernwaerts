import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_type_cubit/calendar_selection_type_state.dart';

/// {@template calendar_selection_type_cubit}
/// A cubit that manages calendarselectiontype state.
/// {@endtemplate}
class CalendarSelectionTypeCubit extends Cubit<CalendarSelectionTypeState> {
/// {@macro calendar_selection_type_cubit}
  CalendarSelectionTypeCubit() : super(const CalendarDaySelection());

  void changeType(CalendarSelectionTypeState calendarSelectionTypeState) {
    emit(calendarSelectionTypeState);
  }
}
