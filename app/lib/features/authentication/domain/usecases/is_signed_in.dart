import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';

/// {@template is_signed_in}
/// Checks if the user is signed in
///
/// Returns:
/// - a [bool] indicating if the user is signed in
/// {@endtemplate}
class IsSignedIn {
  /// {@macro is_signed_in}
  const IsSignedIn({required this.authenticationRepository});

  final AuthenticationRepository authenticationRepository;

  /// {@macro is_signed_in}
  bool call() {
    return authenticationRepository.isSignedIn();
  }
}
