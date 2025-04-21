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
  const InitializeSavedServerConnection({
    required this.authenticationRepository,
  });

  final AuthenticationRepository authenticationRepository;

  /// {@macro initialize_saved_server_connection}
  Future<Either<Failure, None>> call() {
    return _getSavedServerInfo();
  }

  Future<Either<Failure, None>> _getSavedServerInfo() async {
    final Either<Failure, ServerInfo> savedUrlEither =
        await authenticationRepository.getSavedServerInfo();

    return savedUrlEither.fold(Left.new, (ServerInfo serverInfo) {
      return _initializeServerConnection(serverInfo: serverInfo);
    });
  }

  Future<Either<Failure, None>> _initializeServerConnection({
    required ServerInfo serverInfo,
  }) {
    return authenticationRepository.initializeServerConnection(
      serverInfo: serverInfo,
    );
  }
}
