import 'package:intl/intl.dart';

/// {@template number_formatter}
/// Shared locale-aware number formatting helpers.
/// {@endtemplate}
class NumberFormatter {
  /// {@macro number_formatter}
  const NumberFormatter();

  /// Formats a kilometer distance with one decimal place.
  ///
  /// Parameters:
  /// - distance: [double] distance in kilometers.
  /// - languageCode: [String] locale language code used for separators.
  static String formatDistance(double distance, String languageCode) {
    final NumberFormat formatter = NumberFormat('0.0', languageCode);
    return '${formatter.format(distance)} km';
  }
}
