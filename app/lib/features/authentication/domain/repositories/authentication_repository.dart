import 'package:dartz/dartz.dart';
import 'package:location_history/core/failures/authentication/weak_password_failure.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/networking/connection_failure.dart';
import 'package:location_history/core/failures/networking/host_lookup_failure.dart';
import 'package:location_history/core/failures/networking/invalid_server_url_failure.dart';
import 'package:location_history/core/failures/networking/send_timeout_failure.dart';
import 'package:location_history/core/failures/networking/unknown_request_failure.dart';
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
  /// - [SendTimeoutFailure]
  /// - [HostLookupFailure]
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
  /// - [SendTimeoutFailure]
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

  /// Checks if the app has a server connection
  ///
  /// Failures:
  /// - TBD
  Future<Either<Failure, bool>> hasServerConnectionSaved();

  /// Gets the saved server url
  ///
  /// Failures:
  /// - TBD
  Future<Either<Failure, String>> getSavedServerUrl();

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
  /// - [String] username
  /// - [String] password
  ///
  /// Failures:
  /// - TBD
  Future<Either<Failure, None>> signIn({
    required String username,
    required String password,
  });
}
