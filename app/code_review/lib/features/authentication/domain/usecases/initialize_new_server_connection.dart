import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/networking/connection_failure.dart';
import 'package:location_history/core/failures/networking/invalid_server_url_failure.dart';
import 'package:location_history/core/failures/networking/likely_configuration_failure.dart';
import 'package:location_history/features/authentication/domain/models/server_info.dart';
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
  Future<Either<Failure, ServerInfo>> call({required String serverUrl}) async {
    return _isServerConnectionValid(serverUrl: serverUrl);
  }

  Future<Either<Failure, ServerInfo>> _isServerConnectionValid({
    required String serverUrl,
  }) async {
    final Either<Failure, None> isConnectionValidEither =
        await authenticationRepository.isServerConnectionValid(
          serverUrl: serverUrl,
        );

    return isConnectionValidEither.fold(
      (Failure failure) {
        return Left(failure);
      },
      (None none) {
        return _getAnonKeyFromServer(serverUrl: serverUrl);
      },
    );
  }

  Future<Either<Failure, ServerInfo>> _getAnonKeyFromServer({
    required String serverUrl,
  }) async {
    final Either<Failure, String> serverInfoEither =
        await authenticationRepository.getAnonKeyFromServer(
          serverUrl: serverUrl,
        );

    return serverInfoEither.fold(Left.new, (String anonKey) {
      return _initializeServerConnection(
        serverUrl: serverUrl,
        anonKey: anonKey,
      );
    });
  }

  Future<Either<Failure, ServerInfo>> _initializeServerConnection({
    required String serverUrl,
    required String anonKey,
  }) async {
    final ServerInfo serverInfo = ServerInfo(url: serverUrl, anonKey: anonKey);

    final Either<Failure, None> serverInitEither =
        await authenticationRepository.initializeServerConnection(
          serverInfo: serverInfo,
        );

    return serverInitEither.fold(Left.new, (None none) {
      return Right(serverInfo);
    });
  }
}
