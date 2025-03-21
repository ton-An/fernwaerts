import 'package:dartz/dartz.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';

/*
  To-Do:
    - [ ] Add Failures to docs
*/

/// {@template is_server_set_up}
/// Checks if the server is set up. This is used to determine if the initial setup needs to be run.
///
/// Parameters:
/// - [Uri] serverUrl: The URL of the server to check.
///
/// Returns:
/// - a [bool] indicating if the server is set up.
///
/// Failures:
/// - ...TBD...
/// {@endtemplate}
class IsServerSetUp {
  /// {@macro is_server_set_up}
  const IsServerSetUp({required this.authenticationRepository});

  final AuthenticationRepository authenticationRepository;

  /// {@macro is_server_set_up}
  Future<Either<Failure, bool>> call({required Uri serverUrl}) async {
    return await authenticationRepository.isServerSetUp(serverUrl: serverUrl);
  }
}
