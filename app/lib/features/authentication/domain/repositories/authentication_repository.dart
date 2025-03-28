import 'package:dartz/dartz.dart';
import 'package:location_history/core/failures/authentication/weak_password_failure.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/networking/connection_failure.dart';
import 'package:location_history/core/failures/networking/host_lookup_failure.dart';
import 'package:location_history/core/failures/networking/invalid_server_url_failure.dart';
import 'package:location_history/core/failures/networking/send_timeout_failure.dart';
import 'package:location_history/core/failures/networking/unknown_request_failure.dart';

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
  /// - [String] username: The username of the admin user
  /// - [String] email: The email of the admin user
  /// - [String] password: The password of the admin user
  ///
  /// Failures:
  /// - [WeakPasswordFailure]
  /// - [UnknownRequestFailure]
  /// {@macro converted_dio_exceptions}
  Future<Either<Failure, None>> signUpInitialAdmin({
    required String username,
    required String email,
    required String password,
  });
}
