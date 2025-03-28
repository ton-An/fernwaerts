import 'package:dartz/dartz.dart';
import 'package:location_history/core/failures/authentication/password_mismatch_failure.dart';
import 'package:location_history/core/failures/authentication/weak_password_failure.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';

/// Signs up the initial admin user
///
/// Failures:
/// - [WeakPasswordFailure]
class SignUpInitialAdmin {
  const SignUpInitialAdmin({required this.authenticationRepository});

  final AuthenticationRepository authenticationRepository;

  Future<Either<Failure, None>> call({
    required String username,
    required String email,
    required String password,
    required String repeatedPassword,
  }) async {
    if (password != repeatedPassword) {
      return Left(PasswordMismatchFailure());
    }

    return authenticationRepository.signUpInitialAdmin(
      username: username,
      email: email,
      password: password,
    );
  }
}
