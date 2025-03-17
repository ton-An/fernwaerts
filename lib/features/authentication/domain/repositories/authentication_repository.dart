import 'package:dartz/dartz.dart';
import 'package:location_history/core/failures/failure.dart';

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
  /// - ...TBD...
  Future<Either<Failure, bool>> checkServerReachability({
    required Uri serverUrl,
  });

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
  Future<Either<Failure, bool>> checkIfServerSetUp({required Uri serverUrl});
}
