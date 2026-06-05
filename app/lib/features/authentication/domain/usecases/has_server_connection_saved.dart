import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/authentication/no_saved_server_failure.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';
import 'package:location_history/core/failures/storage/storage_read_failure.dart';
import 'package:location_history/features/authentication/domain/models/server_info.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';

/// {@template has_server_connection_saved}
/// Checks whether the app has a server connection saved locally.
///
/// [NoSavedServerFailure] is converted into `false`; other storage failures are
/// returned so callers can distinguish an empty setup from a read problem.
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
    final Either<Failure, ServerInfo> savedServerInfoEither =
        await authenticationRepository.getSavedServerInfo();

    return savedServerInfoEither.fold(
      (Failure failure) {
        if (failure is NoSavedServerFailure) {
          return const Right(false);
        }

        return Left(failure);
      },
      (ServerInfo savedServerInfo) {
        return const Right(true);
      },
    );
  }
}
