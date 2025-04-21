import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/models/server_info.dart';
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
    required ServerInfo serverInfo,
  }) {
    return _signIn(email: email, password: password, serverInfo: serverInfo);
  }

  Future<Either<Failure, None>> _signIn({
    required String email,
    required String password,
    required ServerInfo serverInfo,
  }) async {
    final Either<Failure, None> signInEither = await authenticationRepository
        .signIn(email: email, password: password);

    return signInEither.fold(Left.new, (None none) {
      return _saveServerInfo(serverInfo: serverInfo);
    });
  }

  Future<Either<Failure, None>> _saveServerInfo({
    required ServerInfo serverInfo,
  }) {
    return authenticationRepository.saveServerInfo(serverInfo: serverInfo);
  }
}
