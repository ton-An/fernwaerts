import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_expansion_cubit/calendar_expansion_state.dart';

class CalendarExpansionCubit extends Cubit<CalendarExpansionState> {
  CalendarExpansionCubit() : super(CalendarCollapsed());

  void toggleExpansion() {
    if (state is CalendarCollapsed) {
      emit(CalendarExpanded());
    } else {
      emit(CalendarCollapsed());
    }
  }
}
