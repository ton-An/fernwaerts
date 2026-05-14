import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/networking/connection_failure.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';

/// {@template is_server_set_up}
/// Checks whether the initialized server has completed first-time setup.
///
/// This determines whether the authentication flow should show sign-in or the
/// initial admin setup form.
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
