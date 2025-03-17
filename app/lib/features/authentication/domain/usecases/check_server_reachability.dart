import 'package:dartz/dartz.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';

/*
  To-Do:
    - [ ] Add Failures to docs
*/

/// {@template check_server_reachability}
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
/// {@endtemplate}
class CheckServerReachability {
  final AuthenticationRepository authenticationRepository;

  /// {@macro check_server_reachability}
  const CheckServerReachability({required this.authenticationRepository});

  /// {@macro check_server_reachability}
  Future<Either<Failure, None>> call({required Uri serverUrl}) async {
    return await authenticationRepository.checkServerReachability(
      serverUrl: serverUrl,
    );
  }
}
