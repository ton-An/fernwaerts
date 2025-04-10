import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/authentication/invalid_credentials_failure.dart';
import 'package:location_history/core/failures/authentication/weak_password_failure.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/networking/connection_failure.dart';
import 'package:location_history/core/failures/networking/invalid_server_url_failure.dart';
import 'package:location_history/core/failures/networking/unknown_request_failure.dart';
import 'package:location_history/core/failures/storage/storage_read_failure.dart';
import 'package:location_history/core/failures/storage/storage_write_failure.dart';
import 'package:location_history/features/authentication/domain/models/authentication_state.dart';

/*
  To-Do:
    - [ ] Add TBD Failures
*/

abstract class AuthenticationRepository {
  /// Checks if the server is reachable.
  ///
  /// The server needs to be initialized before this method is called.
  ///
  /// Return:
  /// - [None] if the server is reachable.
  ///
  /// Failures:
  /// {@macro converted_client_exceptions}
  /// - [InvalidUrlFormatFailure]
  /// - [ConnectionFailure]
  Future<Either<Failure, None>> isServerConnectionValid();

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

  /// Initializes the connection to the server
  ///
  /// Parameters:
  /// - [String] serverUrl: The URL of the server to connect to.
  Future<Either<Failure, None>> initializeServerConnection({
    required String serverUrl,
  });

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
  /// - [UnknownRequestFailure]
  /// {@macro converted_dio_exceptions}
  Future<Either<Failure, None>> signUpInitialAdmin({
    required String serverUrl,
    required String username,
    required String email,
    required String password,
  });

  /// Gets the saved server url
  ///
  /// Failures:
  /// - [StorageReadFailure]
  Future<Either<Failure, String?>> getSavedServerUrl();

  /// Checks if the user is signed in
  ///
  /// Returns:
  /// - a [bool] indicating if the user is signed in
  bool isSignedIn();

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

  /// Saves the provided server url
  ///
  /// Parameters:
  /// - [String] serverUrl
  ///
  /// Failures:
  /// - [StorageWriteFailure]
  Future<Either<Failure, None>> saveServerUrl({required String serverUrl});
}
