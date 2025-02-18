import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_expansion_state.freezed.dart';

abstract class CalendarExpansionState {
  const CalendarExpansionState();
}

@freezed
class CalendarExpanded extends CalendarExpansionState with _$CalendarExpanded {
  const factory CalendarExpanded() = _CalendarExpanded;
}

@freezed
class CalendarCollapsed extends CalendarExpansionState
    with _$CalendarCollapsed {
  const factory CalendarCollapsed() = _CalendarCollapsed;
}
