import 'package:flutter_test/flutter_test.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_cubit.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_date_selection_cubit/calendar_date_selection_state.dart';
import 'package:location_history/features/calendar/presentation/cubits/calendar_selection_type_cubit/calendar_selection_type_state.dart';

void main() {
  late CalendarDateSelectionCubit cubit;

  setUp(() {
    cubit = CalendarDateSelectionCubit();
  });

  tearDown(() async {
    await cubit.close();
  });

  group('updateSelection', () {
    test('selects a day', () {
      // arrange
      final selectedDate = DateTime(2026, 6, 2);

      // act
      cubit.updateSelection(
        selectedDate: selectedDate,
        type: const CalendarDaySelection(),
      );

      // assert
      expect(cubit.state, CalendarDaySelected(selectedDate: selectedDate));
    });

    test('builds a custom range in chronological order', () {
      // arrange
      final startDate = DateTime(2026, 6, 10);
      final endDate = DateTime(2026, 6, 12);

      // act
      cubit
        ..updateSelection(
          selectedDate: endDate,
          type: const CalendarRangeSelection(),
        )
        ..updateSelection(
          selectedDate: startDate,
          type: const CalendarRangeSelection(),
        );

      // assert
      expect(
        cubit.state,
        CalendarCustomRangeSelected(startDate: startDate, endDate: endDate),
      );
    });

    test(
      'starts a new custom range when a date inside the range is selected',
      () {
        // arrange
        final startDate = DateTime(2026, 6, 10);
        final endDate = DateTime(2026, 6, 20);
        final newStartDate = DateTime(2026, 6, 15);

        // act
        cubit
          ..updateSelection(
            selectedDate: startDate,
            type: const CalendarRangeSelection(),
          )
          ..updateSelection(
            selectedDate: endDate,
            type: const CalendarRangeSelection(),
          )
          ..updateSelection(
            selectedDate: newStartDate,
            type: const CalendarRangeSelection(),
          );

        // assert
        expect(
          cubit.state,
          CalendarCustomRangeSelected(startDate: newStartDate, endDate: null),
        );
      },
    );

    test('selects a Monday-through-Sunday week', () {
      // act
      cubit.updateSelection(
        selectedDate: DateTime(2026, 6, 4),
        type: const CalendarWeekSelection(),
      );

      // assert
      expect(
        cubit.state,
        CalendarWeekSelected(
          startDate: DateTime(2026, 6, 1),
          endDate: DateTime(2026, 6, 7),
        ),
      );
    });

    test('selects a complete month including leap-day month ends', () {
      // act
      cubit.updateSelection(
        selectedDate: DateTime(2024, 2, 10),
        type: const CalendarMonthSelection(),
      );

      // assert
      expect(
        cubit.state,
        CalendarMonthSelected(
          startDate: DateTime(2024, 2),
          endDate: DateTime(2024, 2, 29),
        ),
      );
    });

    test('selects a complete year', () {
      // act
      cubit.updateSelection(
        selectedDate: DateTime(2026, 6, 2),
        type: const CalendarYearSelection(),
      );

      // assert
      expect(
        cubit.state,
        CalendarYearSelected(
          startDate: DateTime(2026),
          endDate: DateTime(2026, 12, 31),
        ),
      );
    });
  });

  group('shiftSelection', () {
    test('shifts a day and tracks that the selection shifted', () {
      // arrange
      final selectedDate = DateTime(2026, 6, 2);
      cubit.updateSelection(
        selectedDate: selectedDate,
        type: const CalendarDaySelection(),
      );

      // act
      cubit.shiftSelection(forward: true);

      // assert
      expect(
        cubit.state,
        CalendarDaySelected(selectedDate: DateTime(2026, 6, 3)),
      );
      expect(cubit.hasShiftedSelection, isTrue);

      cubit.resetHasShiftedSelection();
      expect(cubit.hasShiftedSelection, isFalse);
    });

    test('shifts an incomplete custom range as a single day', () {
      // arrange
      final selectedDate = DateTime(2026, 6, 2);
      cubit.updateSelection(
        selectedDate: selectedDate,
        type: const CalendarRangeSelection(),
      );

      // act
      cubit.shiftSelection(forward: false);

      // assert
      expect(
        cubit.state,
        CalendarDaySelected(selectedDate: DateTime(2026, 6, 1)),
      );
    });

    test('shifts a complete custom range by its duration', () {
      // arrange
      cubit
        ..updateSelection(
          selectedDate: DateTime(2026, 6, 10),
          type: const CalendarRangeSelection(),
        )
        ..updateSelection(
          selectedDate: DateTime(2026, 6, 15),
          type: const CalendarRangeSelection(),
        );

      // act
      cubit.shiftSelection(forward: true);

      // assert
      expect(
        cubit.state,
        CalendarCustomRangeSelected(
          startDate: DateTime(2026, 6, 15),
          endDate: DateTime(2026, 6, 20),
        ),
      );
    });

    test('shifts a month while preserving the destination month end', () {
      // arrange
      cubit.updateSelection(
        selectedDate: DateTime(2024, 1, 10),
        type: const CalendarMonthSelection(),
      );

      // act
      cubit.shiftSelection(forward: true);

      // assert
      expect(
        cubit.state,
        CalendarMonthSelected(
          startDate: DateTime(2024, 2),
          endDate: DateTime(2024, 2, 29),
        ),
      );
    });

    test('shifts a leap year to a non-leap year', () {
      // arrange
      cubit.updateSelection(
        selectedDate: DateTime(2024, 6, 2),
        type: const CalendarYearSelection(),
      );

      // act
      cubit.shiftSelection(forward: true);

      // assert
      expect(
        cubit.state,
        CalendarYearSelected(
          startDate: DateTime(2025),
          endDate: DateTime(2025, 12, 31),
        ),
      );
    });
  });
}
