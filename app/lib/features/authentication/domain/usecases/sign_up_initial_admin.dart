import 'package:dartz/dartz.dart';
import 'package:location_history/core/failures/authentication/password_mismatch_failure.dart';
import 'package:location_history/core/failures/authentication/weak_password_failure.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';

/*
  To-Do:
    - [ ] Add sign in
*/

/// Signs up the initial admin user
///
/// Parameters:
/// - [String] username: The username of the admin user
/// - [String] email: The email of the admin user
/// - [String] password: The password of the admin user
/// - [String] repeatedPassword: The repeated password of the admin user to confirm it
///
/// Failures:
/// - [WeakPasswordFailure]
/// - [UnknownRequestFailure]
/// {@macro converted_dio_exceptions}
class SignUpInitialAdmin {
  const SignUpInitialAdmin({required this.authenticationRepository});

  final AuthenticationRepository authenticationRepository;

  Future<Either<Failure, None>> call({
    required String serverUrl,
    required String username,
    required String email,
    required String password,
    required String repeatedPassword,
  }) async {
    if (password != repeatedPassword) {
      return Left(PasswordMismatchFailure());
    }

    return authenticationRepository.signUpInitialAdmin(
      serverUrl: serverUrl,
      username: username,
      email: email,
      password: password,
    );
  }
}
