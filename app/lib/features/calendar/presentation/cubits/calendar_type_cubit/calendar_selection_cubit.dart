import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_type_cubit/calendar_selection_type_state.dart';

/// {@template calendar_selection_type_cubit}
/// Tracks the active calendar selection granularity.
///
/// The granularity can be day, custom range, week, month, or year. It decides
/// which calendar view is shown and how `CalendarDateSelectionCubit` converts a
/// selected date into selection state.
/// {@endtemplate}
class CalendarSelectionTypeCubit extends Cubit<CalendarSelectionTypeState> {
  /// {@macro calendar_selection_type_cubit}
  CalendarSelectionTypeCubit() : super(const CalendarDaySelection());

  /// Replaces the active selection type with [calendarSelectionTypeState].
  void changeType(CalendarSelectionTypeState calendarSelectionTypeState) {
    emit(calendarSelectionTypeState);
  }
}
