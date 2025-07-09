import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_type_cubit/calendar_selection_type_state.dart';

class CalendarSelectionTypeCubit extends Cubit<CalendarSelectionTypeState> {
  CalendarSelectionTypeCubit() : super(const CalendarDaySelection());

  void changeType(CalendarSelectionTypeState calendarSelectionTypeState) {
    emit(calendarSelectionTypeState);
  }
}
