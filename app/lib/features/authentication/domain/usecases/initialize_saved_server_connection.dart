import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/authentication/no_saved_server_failure.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/networking/connection_failure.dart';
import 'package:location_history/core/failures/networking/invalid_server_url_failure.dart';
import 'package:location_history/core/failures/storage/storage_read_failure.dart';
import 'package:location_history/features/authentication/domain/models/server_info.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';

/// {@template initialize_saved_server_connection}
/// Initializes the server connection saved by the app
///
/// Failures:
/// - [StorageReadFailure]
/// - [NoSavedServerFailure]
/// {@macro converted_client_exceptions}
/// - [InvalidUrlFormatFailure]
/// - [ConnectionFailure]
/// {@endtemplate}
class InitializeSavedServerConnection {
  /// {@macro initialize_saved_server_connection}
  InitializeSavedServerConnection({required this.authenticationRepository});

  final AuthenticationRepository authenticationRepository;

  bool _isServerSetUp = false;

  /// {@macro initialize_saved_server_connection}
  Future<Either<Failure, None>> call() async {
    if (_isServerSetUp) {
      return const Right(None());
    }

    return _getSavedServerInfo();
  }

  Future<Either<Failure, None>> _getSavedServerInfo() async {
    final Either<Failure, ServerInfo> savedServerEither =
        await authenticationRepository.getSavedServerInfo();

    return savedServerEither.fold(
      (Failure failure) {
        return Left(failure);
      },
      (ServerInfo serverInfo) {
        return _initializeServerConnection(serverInfo: serverInfo);
      },
    );
  }

  Future<Either<Failure, None>> _initializeServerConnection({
    required ServerInfo serverInfo,
  }) async {
    final Either<Failure, None> initServerConnectionEither =
        await authenticationRepository.initializeSupabaseConnection(
          supabaseInfo: serverInfo.supabaseInfo,
        );

    return initServerConnectionEither.fold(Left.new, (None none) {
      return _initializeSyncServerConnection(serverInfo: serverInfo);
    });
  }

  Future<Either<Failure, None>> _initializeSyncServerConnection({
    required ServerInfo serverInfo,
  }) async {
    final Either<Failure, None> initSyncServerConnectionEither =
        await authenticationRepository.initializeSyncServerConnection(
          powersyncInfo: serverInfo.powersyncInfo,
        );

    return initSyncServerConnectionEither.fold(Left.new, (None none) {
      _isServerSetUp = true;

      return const Right(None());
    });
  }
}
