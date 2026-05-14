import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/networking/connection_failure.dart';
import 'package:location_history/core/failures/networking/invalid_server_url_failure.dart';
import 'package:location_history/core/failures/networking/likely_configuration_failure.dart';
import 'package:location_history/features/authentication/domain/models/supabase_info.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';

/// {@template initialize_new_supabase_connection}
/// Initializes a new connection with a Fernwaerts Supabase server.
///
/// The use case validates the provided server URL, fetches the Supabase anon
/// key from the server bootstrap endpoint, initializes Supabase, and returns
/// the connection details needed by the rest of the auth flow.
///
/// Parameters:
/// - serverUrl: [String] URL of the server
///
/// Returns:
/// - [SupabaseInfo] when the server can be initialized
///
/// Failures:
/// {@macro converted_client_exceptions}
/// - [InvalidUrlFormatFailure]
/// - [ConnectionFailure]
/// - [LikelyConfigurationIssueFailure]
/// {@endtemplate}
class InitializeNewSupabaseConnection {
  /// {@macro initialize_new_supabase_connection}
  const InitializeNewSupabaseConnection({
    required this.authenticationRepository,
  });

  final AuthenticationRepository authenticationRepository;

  /// {@macro initialize_new_supabase_connection}
  Future<Either<Failure, SupabaseInfo>> call({
    required String serverUrl,
  }) async {
    return _isServerConnectionValid(serverUrl: serverUrl);
  }

  Future<Either<Failure, SupabaseInfo>> _isServerConnectionValid({
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

  Future<Either<Failure, SupabaseInfo>> _getAnonKeyFromServer({
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

  Future<Either<Failure, SupabaseInfo>> _initializeServerConnection({
    required String serverUrl,
    required String anonKey,
  }) async {
    final SupabaseInfo supabaseInfo = SupabaseInfo(
      url: serverUrl,
      anonKey: anonKey,
    );

    await authenticationRepository.initializeSupabaseConnection(
      supabaseInfo: supabaseInfo,
    );

    return Right(supabaseInfo);
  }
}
