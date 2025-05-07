extension EndOfDayExtension on DateTime {
  DateTime endOfDay() {
    return copyWith(hour: 23, minute: 59, second: 59);
  }
}
