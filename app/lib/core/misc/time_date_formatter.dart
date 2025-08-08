import 'package:intl/intl.dart';

/*
  To-Do:
    - [ ] improve naming
*/

class TimeDateFormatter {
  static String getDuration(DateTime startTime, DateTime endTime) {
    final Duration duration = endTime.difference(startTime);
    if (duration.inHours > 0) {
      return '${duration.inHours}h';
    }
    return '${duration.inMinutes}m';
  }

  static String getTimeFrame(
    DateTime startTime,
    DateTime endTime,
    String languageCode,
  ) {
    return '${DateFormat.Hm(languageCode).format(startTime)} - ${DateFormat.Hm(languageCode).format(endTime)}';
  }

  static String getTime(DateTime time, String languageCode) {
    final DateTime localTime = time.toLocal();

    return DateFormat.Hm(languageCode).format(localTime);
  }
}
