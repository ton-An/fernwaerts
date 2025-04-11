import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_expansion_state.freezed.dart';

abstract class CalendarExpansionState {
  const CalendarExpansionState();
}

@freezed
sealed class CalendarExpanded extends CalendarExpansionState
    with _$CalendarExpanded {
  const factory CalendarExpanded() = _CalendarExpanded;

  const CalendarExpanded._();
}

@freezed
sealed class CalendarCollapsed extends CalendarExpansionState
    with _$CalendarCollapsed {
  const factory CalendarCollapsed() = _CalendarCollapsed;

  const CalendarCollapsed._();
}
