import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';

/*
  To-Do:
    - [ ] Add Failures to docs
    - [ ] Hanlde exception on sign out without internet
*/

/// {@template sign_out}
/// Signs out the current user
///
/// Failures:
/// - [StorageWriteFailure]
/// {@endtemplate}
class SignOut {
  /// {@macro sign_out}
  const SignOut({required this.authenticationRepository});

  final AuthenticationRepository authenticationRepository;

  /// {@macro sign_out}
  Future<Either<Failure, None>> call() {
    return _signOut();
  }

  Future<Either<Failure, None>> _signOut() async {
    await authenticationRepository.signOut();

    return _deleteLocalStorage();
  }

  Future<Either<Failure, None>> _deleteLocalStorage() async {
    final Either<Failure, None> deleteStorageEither =
        await authenticationRepository.deleteLocalStorage();

    return deleteStorageEither.fold(Left.new, (None none) {
      return _deleteLocalDBCache();
    });
  }

  Future<Either<Failure, None>> _deleteLocalDBCache() async {
    await authenticationRepository.deleteLocalDBCache();

    return const Right(None());
  }
}
