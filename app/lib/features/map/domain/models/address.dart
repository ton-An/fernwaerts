import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.freezed.dart';

/// {@template address}
/// Human-readable postal address for a map place.
///
/// The map domain keeps the address separate from [Coordinate] so presentation
/// code can show place context without depending on geocoding or raw location
/// data.
/// {@endtemplate}
@freezed
sealed class Address with _$Address {
  /// {@macro address}
  ///
  /// Parameters:
  /// - street: [String] street and house number when available
  /// - city: [String] locality or city name
  /// - postalCode: [String] postal or ZIP code
  /// - state: [String] region, state, or province
  /// - country: [String] country name
  const factory Address({
    required String street,
    required String city,
    required String postalCode,
    required String state,
    required String country,
  }) = _Address;
}
