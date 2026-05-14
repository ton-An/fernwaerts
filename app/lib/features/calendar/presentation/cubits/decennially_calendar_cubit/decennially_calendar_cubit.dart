import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/features/calendar/presentation/cubits/decennially_calendar_cubit/decennially_calendar_state.dart';

/// {@template decennially_calendar_cubit}
/// Tracks the decade currently focused by decade calendar views.
///
/// This Cubit controls the visible decade page in the calendar carousel.
/// {@endtemplate}
class DecenniallyCalendarCubit extends Cubit<DecenniallyCalendarState> {
  /// {@macro decennially_calendar_cubit}
  DecenniallyCalendarCubit()
    : super(
        DecenniallyCalendarState(
          startYear: DateTime(2020),
          endYear: DateTime(2029),
        ),
      );

  static const _yearsInDecade = 10;

  /// Moves the focused decade ten years backward.
  void showPreviousDecade() {
    emit(
      DecenniallyCalendarState(
        startYear: DateTime(state.startYear.year - _yearsInDecade),
        endYear: DateTime(state.endYear.year - _yearsInDecade),
      ),
    );
  }

  /// Moves the focused decade ten years forward.
  void showNextDecade() {
    emit(
      DecenniallyCalendarState(
        startYear: DateTime(state.startYear.year + _yearsInDecade),
        endYear: DateTime(state.endYear.year + _yearsInDecade),
      ),
    );
  }

  /// Moves the focused decade by [offset] decade pages from the current focus.
  void showDecadeAtOffset(int offset) {
    emit(
      DecenniallyCalendarState(
        startYear: DateTime(state.startYear.year + (offset * _yearsInDecade)),
        endYear: DateTime(state.endYear.year + (offset * _yearsInDecade)),
      ),
    );
  }

  /// Focuses the decade containing [startYear].
  void showDecade(DateTime startYear) {
    final int startOfDecade =
        startYear.year - (startYear.year % _yearsInDecade);

    emit(
      DecenniallyCalendarState(
        startYear: DateTime(startOfDecade),
        endYear: DateTime(startOfDecade + _yearsInDecade - 1),
      ),
    );
  }
}
