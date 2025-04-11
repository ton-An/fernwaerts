import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.freezed.dart';

@freezed
sealed class Address with _$Address {
  const factory Address({
    required String street,
    required String city,
    required String postalCode,
    required String state,
    required String country,
  }) = _Address;
}
