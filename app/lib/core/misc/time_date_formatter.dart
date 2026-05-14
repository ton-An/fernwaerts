import 'package:intl/intl.dart';

/*
  To-Do:
    - [ ] improve naming
*/

/// {@template time_date_formatter}
/// Shared locale-aware time and duration formatting helpers.
/// {@endtemplate}
class TimeDateFormatter {
  /// {@macro time_date_formatter}
  const TimeDateFormatter();

  /// Formats the difference between [startTime] and [endTime] as hours or
  /// minutes.
  static String getDuration(DateTime startTime, DateTime endTime) {
    final Duration duration = endTime.difference(startTime);
    if (duration.inHours > 0) {
      return '${duration.inHours}h';
    }
    return '${duration.inMinutes}m';
  }

  /// Formats a local time range using 24-hour hour/minute formatting.
  ///
  /// Parameters:
  /// - startTime: [DateTime] range start.
  /// - endTime: [DateTime] range end.
  /// - languageCode: [String] locale language code.
  static String getTimeFrame(
    DateTime startTime,
    DateTime endTime,
    String languageCode,
  ) {
    return '${DateFormat.Hm(languageCode).format(startTime)} - ${DateFormat.Hm(languageCode).format(endTime)}';
  }

  /// Formats [time] in local time using 24-hour hour/minute formatting.
  ///
  /// Parameters:
  /// - time: [DateTime] value to format.
  /// - languageCode: [String] locale language code.
  static String getTime(DateTime time, String languageCode) {
    final DateTime localTime = time.toLocal();

    return DateFormat.Hm(languageCode).format(localTime);
  }
}
