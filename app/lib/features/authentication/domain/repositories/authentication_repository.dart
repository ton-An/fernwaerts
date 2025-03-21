import 'package:dartz/dartz.dart';
import 'package:location_history/core/failures/failure.dart';

/*
  To-Do:
    - [ ] Add Failures to docs
*/
abstract class AuthenticationRepository {
  /// Checks if the server is reachable.
  ///
  /// Parameters:
  /// - [Uri] serverUrl: The URL of the server to check.
  ///
  /// Returns:
  /// - a [bool] indicating if the server is reachable.
  ///
  /// Failures:
  /// - {@macro server_remote_handler_exceptions}
  Future<Either<Failure, None>> isServerReachable({required Uri serverUrl});

  /// Checks if the server is set up.
  ///
  /// Parameters:
  /// - [Uri] serverUrl: The URL of the server to check.
  ///
  /// Returns:
  /// - a [bool] indicating if the server is set up.
  ///
  /// Failures:
  /// - ...TBD...
  Future<Either<Failure, bool>> isServerSetUp({required Uri serverUrl});
}
