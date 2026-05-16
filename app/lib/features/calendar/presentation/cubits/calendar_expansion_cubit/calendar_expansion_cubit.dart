import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_expansion_cubit/calendar_expansion_state.dart';

/// {@template calendar_expansion_cubit}
/// Tracks whether the calendar panel is expanded below the calendar stepper.
///
/// The expansion state drives the calendar composite's translation, fade, and
/// visibility.
/// {@endtemplate}
class CalendarExpansionCubit extends Cubit<CalendarExpansionState> {
  /// {@macro calendar_expansion_cubit}
  CalendarExpansionCubit() : super(const CalendarCollapsed());

  /// Toggles between [CalendarCollapsed] and [CalendarExpanded].
  void toggleExpansion() {
    if (state is CalendarCollapsed) {
      emit(const CalendarExpanded());
    } else {
      emit(const CalendarCollapsed());
    }
  }
}
