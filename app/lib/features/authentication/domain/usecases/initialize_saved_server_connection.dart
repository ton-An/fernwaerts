import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/authentication/no_saved_server_failure.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/networking/connection_failure.dart';
import 'package:location_history/core/failures/networking/invalid_server_url_failure.dart';
import 'package:location_history/core/failures/storage/storage_read_failure.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:location_history/features/authentication/domain/usecases/initialize_server_connection.dart';

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
    required this.initializeServerConnection,
  });

  final AuthenticationRepository authenticationRepository;
  final InitializeServerConnection initializeServerConnection;

  /// {@macro initialize_saved_server_connection}
  Future<Either<Failure, None>> call() {
    return _getSavedServerUrl();
  }

  Future<Either<Failure, None>> _getSavedServerUrl() async {
    final Either<Failure, String?> savedUrlEither =
        await authenticationRepository.getSavedServerUrl();

    return savedUrlEither.fold(Left.new, (String? serverUrl) {
      if (serverUrl == null) {
        return const Left(NoSavedServerFailure());
      }

      return _initializeServerConnection(serverUrl: serverUrl);
    });
  }

  Future<Either<Failure, None>> _initializeServerConnection({
    required String serverUrl,
  }) {
    return initializeServerConnection(serverUrl: serverUrl);
  }
}
