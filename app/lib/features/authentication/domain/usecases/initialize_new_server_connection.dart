import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/networking/connection_failure.dart';
import 'package:location_history/core/failures/networking/invalid_server_url_failure.dart';
import 'package:location_history/core/failures/networking/likely_configuration_failure.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';

/// {@template initialize_new_server_connection}
/// Initializes a new connection with a server
///
/// Parameters:
/// - [Uri] serverUrl: The URL of the server
///
/// Return:
/// - [None] if the server is reachable
///
/// Failures:
/// {@macro converted_client_exceptions}
/// - [InvalidUrlFormatFailure]
/// - [ConnectionFailure]
/// - [LikelyConfigurationIssueFailure]
/// {@endtemplate}
class InitializeNewServerConnection {
  /// {@macro initialize_server_connection}
  const InitializeNewServerConnection({required this.authenticationRepository});

  final AuthenticationRepository authenticationRepository;

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
