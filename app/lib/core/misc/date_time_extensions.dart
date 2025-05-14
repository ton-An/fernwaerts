extension EndOfDayExtension on DateTime {
  DateTime endOfDay() {
    return copyWith(hour: 23, minute: 59, second: 59);
  }
}

extension ISOStringWithTZ on DateTime {
  String toIso8601StringWithTz() {
    final timeZoneOffset = this.timeZoneOffset;
    final sign = timeZoneOffset.isNegative ? '-' : '+';
    final hours = timeZoneOffset.inHours.abs().toString().padLeft(2, '0');
    final minutes = timeZoneOffset.inMinutes
        .abs()
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    final offsetString = '$sign$hours:$minutes';

    // Get first part of properly formatted ISO 8601 date
    final formattedDate = toIso8601String().split('.').first;

    return '$formattedDate$offsetString';
  }
}
