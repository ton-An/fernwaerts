import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/networking/connection_failure.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';

/*
  To-Do:
    - [ ] Add Failures to docs
*/

/// {@template is_server_set_up}
/// Checks if the server is set up. This is used to determine if the initial setup needs to be run.
///
/// Returns:
/// - a [bool] indicating if the server is set up.
///
/// Failures:
/// {@macro converted_client_exceptions}
/// - [ConnectionFailure]
/// {@endtemplate}
class IsServerSetUp {
  /// {@macro is_server_set_up}
  const IsServerSetUp({required this.authenticationRepository});

  final AuthenticationRepository authenticationRepository;

  /// {@macro is_server_set_up}
  Future<Either<Failure, bool>> call() {
    return authenticationRepository.isServerSetUp();
  }
}
