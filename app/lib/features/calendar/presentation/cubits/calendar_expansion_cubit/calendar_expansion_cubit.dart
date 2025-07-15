import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_expansion_cubit/calendar_expansion_state.dart';

/// {@template calendar_expansion_cubit}
/// A cubit that manages calendarexpansion state.
/// {@endtemplate}
class CalendarExpansionCubit extends Cubit<CalendarExpansionState> {
/// {@macro calendar_expansion_cubit}
  CalendarExpansionCubit() : super(const CalendarCollapsed());

  void toggleExpansion() {
    if (state is CalendarCollapsed) {
      emit(const CalendarExpanded());
    } else {
      emit(const CalendarCollapsed());
    }
  }
}
