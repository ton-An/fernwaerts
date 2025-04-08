import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/storage/storage_read_failure.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';

/*
  To-Do:
    - [ ] Add Failures to docs
*/

/// {@template has_server_connection_saved}
/// Checks if the app has a server connection saved
///
/// Returns:
/// - a [bool] indicating if there is a saved server connection
///
/// Failures:
/// - [StorageReadFailure]
/// {@endtemplate}
class HasServerConnectionSaved {
  /// {@macro has_server_connection_saved}
  const HasServerConnectionSaved({required this.authenticationRepository});

  final AuthenticationRepository authenticationRepository;

  /// {@macro has_server_connection_saved}
  Future<Either<Failure, bool>> call() {
    return _hasServerConnectionSaved();
  }

  Future<Either<Failure, bool>> _hasServerConnectionSaved() async {
    final Either<Failure, String?> savedServerUrlEither =
        await authenticationRepository.getSavedServerUrl();

    return savedServerUrlEither.fold(Left.new, (String? savedServerUrl) {
      if (savedServerUrl != null) {
        return Right(true);
      }

      return Right(false);
    });
  }
}
