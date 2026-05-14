import 'package:location_history/features/authentication/domain/models/authentication_state.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';

/// {@template authentication_state_stream}
/// Subscribes to domain authentication state changes.
///
/// Emits:
/// - [SignedInState] when the auth provider reports an active session
/// - [SignedOutState] when the auth provider reports no active session
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
