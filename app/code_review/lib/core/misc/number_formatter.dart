import 'package:intl/intl.dart';

class NumberFormatter {
  static String formatDistance(double distance, String languageCode) {
    final NumberFormat formatter = NumberFormat('0.#', languageCode);
    return '${formatter.format(distance)} km';
  }
}
