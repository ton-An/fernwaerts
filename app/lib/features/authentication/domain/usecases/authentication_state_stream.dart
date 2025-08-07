import 'package:location_history/features/authentication/domain/models/authentication_state.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';

/*
  To-Do:
    - [ ] Implement this in presentation
*/

/// {@template authentication_state_stream}
/// Notifies when the authentication state changes
///
/// Emits:
/// - An [AuthenticationState]
/// {@endtemplate}
class AuthenticationStateStream {
  /// {@macro authentication_state_stream}
  const AuthenticationStateStream({required this.authenticationRepository});

  final AuthenticationRepository authenticationRepository;

  /// {@macro authentication_state_stream}
  Stream<AuthenticationState> call() {
    return authenticationRepository.authenticationStateStream();
  }
}
