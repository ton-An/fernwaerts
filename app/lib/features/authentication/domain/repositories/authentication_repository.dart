import 'package:fpdart/fpdart.dart';
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

abstract class AuthenticationRepository {
  /// Checks if the server is reachable.
  ///
  /// Parameters:
  /// - [String] serverUrl: The URL of the server to connect to
  ///
  /// Return:
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
  /// {@macro converted_client_exceptions}
  /// - [ConnectionFailure]
  Future<Either<Failure, bool>> isServerSetUp();

  /// Initializes the connection to the supabase server
  ///
  /// Parameters:
  /// - [SupabaseInfo] supabaseInfo: The URL of the server to connect to.
  Future<void> initializeSupabaseConnection({
    required SupabaseInfo supabaseInfo,
  });

  /// Initializes the connection to the sync server
  ///
  /// #### ! [initializeSupabaseConnection] needs to be called before this method !
  ///
  /// Parameters:
  /// - [PowersyncInfo] powerSyncInfo: The info of the sync server to connect to.
  ///
  /// Failures:
  /// - TBD
  Future<Either<Failure, None>> initializeSyncServerConnection({
    required PowersyncInfo powersyncInfo,
  });

  /// Gets sync server info
  ///
  /// Returns:
  /// - [PowersyncInfo] powerSyncInfo: The URL of the server to connect to.
  ///
  /// Failures:
  /// - TBD
  Future<Either<Failure, PowersyncInfo>> getSyncServerInfo();

  /// Signs up the initial admin user
  ///
  /// Parameters:
  /// - [String] serverUrl: The URL of the server to connect to
  /// - [String] username: The username of the admin user
  /// - [String] email: The email of the admin user
  /// - [String] password: The password of the admin user
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

  /// Gets the saved server info
  ///
  /// Failures:
  /// - [StorageReadFailure]
  /// - [NoSavedServerFailure]
  Future<Either<Failure, ServerInfo>> getSavedServerInfo();

  /// Checks if the user is signed in
  ///
  /// Returns:
  /// - a [bool] indicating if the user is signed in
  Future<bool> isSignedIn();

  /// Notifies when the authentication state changes
  ///
  /// Emits:
  /// - An [AuthenticationState]
  Stream<AuthenticationState> authenticationStateStream();

  /// Signs in a user
  ///
  /// Parameters:
  /// - [String] email
  /// - [String] password
  ///
  /// Failures:
  /// {@macro converted_client_exceptions}
  /// - [InvalidCredentialsFailure]
  Future<Either<Failure, None>> signIn({
    required String email,
    required String password,
  });

  /// Signs out the current user
  Future<void> signOut();

  /// Removes the saved server
  ///
  /// Failures:
  /// - [StorageWriteFailure]
  Future<Either<Failure, None>> removeSavedServer();

  /// Deletes local storage
  ///
  /// Failures:
  /// - [StorageWriteFailure]
  Future<Either<Failure, None>> deleteLocalStorage();

  /// Deletes local DB cache
  Future<void> deleteLocalDBCache();

  /// Saves the provided server info
  ///
  /// Parameters:
  /// - [ServerInfo] serverInfo
  ///
  /// Failures:
  /// - [StorageWriteFailure]
  Future<Either<Failure, None>> saveServerInfo({
    required ServerInfo serverInfo,
  });

  /// Gets the Supabase anon key from the server
  ///
  /// Parameters:
  /// - [String] serverUrl
  ///
  /// Returns:
  /// - a [String] containing the Supabase anon key
  ///
  /// Failures:
  /// {@macro converted_dio_exceptions}
  Future<Either<Failure, String>> getAnonKeyFromServer({
    required String serverUrl,
  });

  /// Gets the current user's id
  ///
  /// Returns:
  /// - a [String] containing the current user's id
  ///
  /// Failures:
  /// - [NotSignedInFailure]
  Future<Either<Failure, String>> getCurrentUserId();
}
