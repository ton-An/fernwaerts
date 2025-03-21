import 'package:dartz/dartz.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';

/*
  To-Do:
    - [ ] Add Failures to docs
*/

/// {@template is_server_reachable}
/// Checks if the server is reachable.
///
/// Parameters:
/// - [Uri] serverUrl: The URL of the server to check.
///
/// Return:
/// - [None] if the server is reachable.
///
/// Failures:
/// - {@macro server_remote_handler_exceptions}
/// {@endtemplate}
class IsServerReachable {
  final AuthenticationRepository authenticationRepository;

  /// {@macro is_server_reachable}
  const IsServerReachable({required this.authenticationRepository});

  /// {@macro is_server_reachable}
  Future<Either<Failure, None>> call({required Uri serverUrl}) async {
    return await authenticationRepository.isServerReachable(
      serverUrl: serverUrl,
    );
  }
}
