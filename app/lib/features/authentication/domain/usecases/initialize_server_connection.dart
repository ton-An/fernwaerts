import 'package:dartz/dartz.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/networking/connection_failure.dart';
import 'package:location_history/core/failures/networking/host_lookup_failure.dart';
import 'package:location_history/core/failures/networking/invalid_server_url_failure.dart';
import 'package:location_history/core/failures/networking/send_timeout_failure.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';

/// {@template initialize_server_connection}
/// Initializes the connection with the server
///
/// Parameters:
/// - [Uri] serverUrl: The URL of the server to check.
///
/// Return:
/// - [None] if the server is reachable.
///
/// Failures:
/// - [SendTimeoutFailure]
/// - [HostLookupFailure]
/// - [InvalidUrlFormatFailure]
/// - [ConnectionFailure]
/// {@endtemplate}
class InitializeServerConnection {
  final AuthenticationRepository authenticationRepository;

  /// {@macro initialize_server_connection}
  const InitializeServerConnection({required this.authenticationRepository});

  /// {@macro initialize_server_connection}
  Future<Either<Failure, None>> call({required String serverUrl}) async {
    return _initializeServerConnection(serverUrl: serverUrl);
  }

  Future<Either<Failure, None>> _initializeServerConnection({
    required String serverUrl,
  }) async {
    final Either<Failure, None> serverInitEither =
        await authenticationRepository.initializeServerConnection(
          serverUrl: serverUrl,
        );

    return serverInitEither.fold(Left.new, (None none) {
      return _isServerConnectionValid();
    });
  }

  Future<Either<Failure, None>> _isServerConnectionValid() async {
    return authenticationRepository.isServerConnectionValid();
  }
}
