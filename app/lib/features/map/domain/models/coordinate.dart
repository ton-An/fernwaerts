import 'package:freezed_annotation/freezed_annotation.dart';

part 'coordinate.freezed.dart';

/// {@template coordinate}
/// Geographic coordinate used by the map domain.
///
/// Coordinates are stored as decimal degrees and are intentionally minimal so
/// domain models do not depend on a map rendering package's coordinate type.
/// {@endtemplate}
@freezed
sealed class Coordinate with _$Coordinate {
  /// {@macro coordinate}
  ///
  /// Parameters:
  /// - latitude: [double] north-south position in decimal degrees
  /// - longitude: [double] east-west position in decimal degrees
  const factory Coordinate({
    required double latitude,
    required double longitude,
  }) = _Coordinate;
}
