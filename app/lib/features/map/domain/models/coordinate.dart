import 'package:freezed_annotation/freezed_annotation.dart';

part 'coordinate.freezed.dart';

@freezed
sealed class Coordinate with _$Coordinate {
  const factory Coordinate({
    required double latitude,
    required double longitude,
  }) = _Coordinate;
}
