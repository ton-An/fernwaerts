import 'package:dartz/dartz.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';

/*
  To-Do:
    - [ ] Add Failures to docs
*/

/// {@template sign_in}
/// Signs in a user with a given email and password
///
/// Parameters:
/// - [String] email
/// - [String] password
///
/// Failures:
/// {@macro converted_client_exceptions}
/// {@endtemplate}
class SignIn {
  /// {@macro sign_in}
  const SignIn({required this.authenticationRepository});

  final AuthenticationRepository authenticationRepository;

  /// {@macro sign_in}
  Future<Either<Failure, None>> call({
    required String email,
    required String password,
  }) {
    return authenticationRepository.signIn(email: email, password: password);
  }
}
