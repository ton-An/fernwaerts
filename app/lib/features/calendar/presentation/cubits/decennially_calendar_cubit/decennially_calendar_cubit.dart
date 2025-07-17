import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/features/calendar/presentation/cubits/decennially_calendar_cubit/decennially_calendar_state.dart';

class DecenniallyCalendarCubit extends Cubit<DecenniallyCalendarState> {
  DecenniallyCalendarCubit()
    : super(
        DecenniallyCalendarState(
          startYear: DateTime(2020),
          endYear: DateTime(2029),
        ),
      );

  static const _yearsInDecade = 10;

  void showPreviousDecade() {
    emit(
      DecenniallyCalendarState(
        startYear: DateTime(state.startYear.year - _yearsInDecade),
        endYear: DateTime(state.endYear.year - _yearsInDecade),
      ),
    );
  }

  void showNextDecade() {
    emit(
      DecenniallyCalendarState(
        startYear: DateTime(state.startYear.year + _yearsInDecade),
        endYear: DateTime(state.endYear.year + _yearsInDecade),
      ),
    );
  }

  void showDecadeAtOffset(int offset) {
    emit(
      DecenniallyCalendarState(
        startYear: DateTime(state.startYear.year + (offset * _yearsInDecade)),
        endYear: DateTime(state.endYear.year + (offset * _yearsInDecade)),
      ),
    );
  }

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
