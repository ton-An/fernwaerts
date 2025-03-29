import 'package:dartz/dartz.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';

/*
  To-Do:
    - [ ] Add Failures to docs
*/

/// {@template has_server_connection_saved}
/// Checks if the app has a server connection saved
///
/// Returns:
/// - a [bool] indicating if there is a saved server connection
///
/// Failures:
/// - TBD
/// {@endtemplate}
class HasServerConnectionSaved {
  /// {@macro has_server_connection_saved}
  const HasServerConnectionSaved({required this.authenticationRepository});

  final AuthenticationRepository authenticationRepository;

  /// {@macro has_server_connection_saved}
  Future<Either<Failure, bool>> call() {
    return authenticationRepository.hasServerConnectionSaved();
  }
}
