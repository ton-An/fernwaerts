/// Calendar-day helper for inclusive date range queries.
extension EndOfDayExtension on DateTime {
  /// Returns this date at `23:59:59` in the same time zone.
  DateTime endOfDay() {
    return copyWith(hour: 23, minute: 59, second: 59);
  }
}

/// ISO-8601 formatting helper that preserves the local UTC offset.
extension ISOStringWithTZ on DateTime {
  /// Returns an ISO-8601 timestamp without fractional seconds and with a
  /// `+HH:mm` or `-HH:mm` offset suffix.
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
