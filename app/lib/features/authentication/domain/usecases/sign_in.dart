import 'package:fpdart/fpdart.dart';
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
/// - [InvalidCredentialsFailure]
/// {@endtemplate}
class SignIn {
  /// {@macro sign_in}
  const SignIn({required this.authenticationRepository});

  final AuthenticationRepository authenticationRepository;

  /// {@macro sign_in}
  Future<Either<Failure, None>> call({
    required String email,
    required String password,
    required String serverUrl,
  }) {
    return _signIn(email: email, password: password, serverUrl: serverUrl);
  }

  Future<Either<Failure, None>> _signIn({
    required String email,
    required String password,
    required String serverUrl,
  }) async {
    final Either<Failure, None> signInEither = await authenticationRepository
        .signIn(email: email, password: password);

    return signInEither.fold(Left.new, (None none) {
      return _saveServerUrl(serverUrl: serverUrl);
    });
  }

  Future<Either<Failure, None>> _saveServerUrl({required String serverUrl}) {
    return authenticationRepository.saveServerUrl(serverUrl: serverUrl);
  }
}
