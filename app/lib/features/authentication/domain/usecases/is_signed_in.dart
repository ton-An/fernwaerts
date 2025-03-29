import 'package:dartz/dartz.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';

/*
  To-Do:
    - [ ] Add Failures to docs
*/

/// {@template is_signed_in}
/// Checks if the user is signed in
///
/// Returns:
/// - a [bool] indicating if the user is signed in
///
/// Failures:
/// - TBD
/// {@endtemplate}
class IsSignedIn {
  /// {@macro is_signed_in}
  const IsSignedIn({required this.authenticationRepository});

  final AuthenticationRepository authenticationRepository;

  /// {@macro is_signed_in}
  Future<Either<Failure, bool>> call() {
    return authenticationRepository.isSignedIn();
  }
}
