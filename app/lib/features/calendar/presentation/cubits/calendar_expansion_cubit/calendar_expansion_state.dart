import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_expansion_state.freezed.dart';

/// {@template calendar_expansion_state}
/// Base state for the calendar panel visibility below the stepper.
/// {@endtemplate}
abstract class CalendarExpansionState {
  /// {@macro calendar_expansion_state}
  const CalendarExpansionState();
}

/// {@template calendar_expanded}
/// The calendar panel is visible and interactive.
/// {@endtemplate}
@freezed
sealed class CalendarExpanded extends CalendarExpansionState
    with _$CalendarExpanded {
  /// {@macro calendar_expanded}
  const factory CalendarExpanded() = _CalendarExpanded;

  const CalendarExpanded._();
}

/// {@template calendar_collapsed}
/// The calendar panel is hidden, leaving only the stepper visible.
/// {@endtemplate}
@freezed
sealed class CalendarCollapsed extends CalendarExpansionState
    with _$CalendarCollapsed {
  /// {@macro calendar_collapsed}
  const factory CalendarCollapsed() = _CalendarCollapsed;

  const CalendarCollapsed._();
}
