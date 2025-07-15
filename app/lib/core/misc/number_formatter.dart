import 'package:intl/intl.dart';

/// {@template number_formatter}
/// A class that represents NumberFormatter.
/// {@endtemplate}
class NumberFormatter {
  static String formatDistance(double distance, String languageCode) {
    final NumberFormat formatter = NumberFormat('0.#', languageCode);
    return '${formatter.format(distance)} km';
  }
}
