import 'package:dartz/dartz.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';

/*
  To-Do:
    - [ ] Add Failures to docs
*/

/// {@template dispose_server_connection}
/// Disposes the connection with the server
/// {@endtemplate}
class DisposeServerConnection {
  final AuthenticationRepository authenticationRepository;

  /// {@macro dispose_server_connection}
  const DisposeServerConnection({required this.authenticationRepository});

  /// {@macro dispose_server_connection}
  Future<Either<Failure, None>> call({required Uri serverUrl}) {
    return authenticationRepository.disposeServerConnection();
  }
}
