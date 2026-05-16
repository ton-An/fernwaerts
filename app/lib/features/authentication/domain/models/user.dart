import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

/// {@template user}
/// Authenticated Fernwaerts user profile exposed to the app domain.
/// {@endtemplate}
@freezed
sealed class User with _$User {
  /// {@macro user}
  const factory User({
    required String id,
    required String username,
    required String email,
  }) = _User;
}
