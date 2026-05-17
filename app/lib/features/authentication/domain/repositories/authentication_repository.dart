import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/authentication/account_already_set_up_failure.dart';
import 'package:location_history/core/failures/authentication/expired_refresh_token_failure.dart';
import 'package:location_history/core/failures/authentication/invalid_credentials_failure.dart';
import 'package:location_history/core/failures/authentication/no_saved_server_failure.dart';
import 'package:location_history/core/failures/authentication/not_signed_in_failure.dart';
import 'package:location_history/core/failures/authentication/weak_password_failure.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/networking/connection_failure.dart';
import 'package:location_history/core/failures/storage/storage_read_failure.dart';
import 'package:location_history/core/failures/storage/storage_write_failure.dart';
import 'package:location_history/features/authentication/domain/models/authentication_state.dart';
import 'package:location_history/features/authentication/domain/models/powersync_info.dart';
import 'package:location_history/features/authentication/domain/models/server_info.dart';
import 'package:location_history/features/authentication/domain/models/supabase_info.dart';

/// {@template authentication_repository}
/// Domain contract for authentication, saved server setup, and session state.
///
/// Callers should use this contract to configure the selected server, persist
/// connection details, and access the current user's session state.
/// {@endtemplate}
abstract class AuthenticationRepository {
  /// {@macro authentication_repository}
  const AuthenticationRepository();

  /// Checks if the server is reachable.
  ///
  /// Parameters:
  /// - serverUrl: [String] URL of the server to connect to
  ///
  /// Returns:
  /// - [None] if the server is reachable.
  ///
  /// Failures:
  /// {@macro converted_dio_exceptions}
  Future<Either<Failure, None>> isServerConnectionValid({
    required String serverUrl,
  });

  /// Checks if the server is set up.
  ///
  /// The server needs to be initialized before this method is called.
  ///
  /// Returns:
  /// - a [bool] indicating if the server is set up.
  ///
  /// Failures:
  /// - [ConnectionFailure]
  /// {@macro converted_client_exceptions}
  Future<Either<Failure, bool>> isServerSetUp();

  /// Initializes the connection to the auth server.
  ///
  /// This prepares the auth client for calls that require a configured server.
  ///
  /// Parameters:
  /// - supabaseInfo: [SupabaseInfo] connection info for the server
  Future<void> initializeSupabaseConnection({
    required SupabaseInfo supabaseInfo,
  });

  /// Initializes the connection to the sync server.
  ///
  /// [initializeSupabaseConnection] must be called first so the sync client can
  /// authenticate against the same server.
  ///
  /// Parameters:
  /// - powersyncInfo: [PowersyncInfo] info of the sync server to connect to
  Future<void> initializeSyncServerConnection({
    required PowersyncInfo powersyncInfo,
  });

  /// Gets sync server info from the configured server.
  ///
  /// Returns:
  /// - [PowersyncInfo] for the configured sync server
  ///
  /// Failures:
  /// {@macro converted_client_exceptions}
  /// {@macro converted_supabase_functions_exception}
  Future<Either<Failure, PowersyncInfo>> getSyncServerInfo();

  /// Signs up the initial admin user.
  ///
  /// This is only valid during first-server setup before a normal sign-in flow
  /// exists for the instance.
  ///
  /// Parameters:
  /// - serverUrl: [String] URL of the server to connect to
  /// - username: [String] username of the admin user
  /// - email: [String] email of the admin user
  /// - password: [String] password of the admin user
  ///
  /// Failures:
  /// - [WeakPasswordFailure]
  /// {@macro converted_dio_exceptions}
  Future<Either<Failure, None>> signUpInitialAdmin({
    required String serverUrl,
    required String username,
    required String email,
    required String password,
  });

  /// Completes account setup for the currently authenticated invited user.
  ///
  /// Parameters:
  /// - username: [String] username for the invited user
  /// - password: [String] password for the invited user
  ///
  /// Failures:
  /// - [WeakPasswordFailure]
  /// - [AccountAlreadySetUpFailure]
  /// {@macro converted_client_exceptions}
  /// {@macro converted_supabase_functions_exception}
  Future<Either<Failure, None>> signUpInvitedUser({
    required String username,
    required String password,
  });

  /// Recovers the temporary auth session from a Supabase invite refresh token.
  ///
  /// Parameters:
  /// - refreshToken: [String] refresh token from the Supabase invite callback
  ///
  /// Failures:
  /// - [ExpiredRefreshTokenFailure]
  /// {@macro converted_client_exceptions}
  Future<Either<Failure, None>> recoverInviteSession({
    required String refreshToken,
  });

  /// Gets the saved server info needed to restore a previous connection.
  ///
  /// Failures:
  /// - [StorageReadFailure]
  /// - [NoSavedServerFailure]
  Future<Either<Failure, ServerInfo>> getSavedServerInfo();

  /// Checks if the configured auth client has a current signed-in user.
  ///
  /// Returns:
  /// - a [bool] indicating if the user is signed in
  Future<bool> isSignedIn();

  /// Notifies when the configured auth client's session state changes.
  ///
  /// Emits:
  /// - An [AuthenticationState]
  Stream<AuthenticationState> authenticationStateStream();

  /// Signs in a user against the currently initialized auth connection.
  ///
  /// Parameters:
  /// - email: [String] email of the user
  /// - password: [String] password of the user
  ///
  /// Failures:
  /// - [InvalidCredentialsFailure]
  /// {@macro converted_client_exceptions}
  Future<Either<Failure, None>> signIn({
    required String email,
    required String password,
  });

  /// Signs out the current user from the configured auth client.
  Future<void> signOut();

  /// Removes the saved server info from local storage.
  ///
  /// Failures:
  /// - [StorageWriteFailure]
  Future<Either<Failure, None>> removeSavedServer();

  /// Deletes local authentication and server storage.
  ///
  /// Failures:
  /// - [StorageWriteFailure]
  Future<Either<Failure, None>> deleteLocalStorage();

  /// Deletes locally cached database state for the signed-out session.
  Future<void> deleteLocalDBCache();

  /// Saves the provided server info
  ///
  /// Parameters:
  /// - serverInfo: [ServerInfo] to save
  ///
  /// Failures:
  /// - [StorageWriteFailure]
  Future<Either<Failure, None>> saveServerInfo({
    required ServerInfo serverInfo,
  });

  /// Gets the auth anon key from the server bootstrap endpoint.
  ///
  /// Parameters:
  /// - serverUrl: [String] URL of the server to query
  ///
  /// Returns:
  /// - a [String] containing the auth anon key
  ///
  /// Failures:
  /// {@macro converted_dio_exceptions}
  Future<Either<Failure, String>> getAnonKeyFromServer({
    required String serverUrl,
  });

  /// Gets the current signed-in user's id.
  ///
  /// Returns:
  /// - a [String] containing the current user's id
  ///
  /// Failures:
  /// - [NotSignedInFailure]
  Future<Either<Failure, String>> getCurrentUserId();

  /// Gets the current signed-in user's email.
  ///
  /// Returns:
  /// - a [String] containing the current user's email
  ///
  /// Failures:
  /// - [NotSignedInFailure]
  Future<Either<Failure, String>> getCurrentUserEmail();

  /// Checks if the sync server is reachable.
  ///
  /// Parameters:
  /// - syncServerUrl: [String] URL of the sync server to connect to
  ///
  /// Returns:
  /// - [None] if the server is reachable.
  ///
  /// Failures:
  /// {@macro converted_dio_exceptions}
  Future<Either<Failure, None>> isSyncServerConnectionValid({
    required String syncServerUrl,
  });
}
