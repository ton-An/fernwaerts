import 'package:location_history/features/authentication/domain/models/authentication_state.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';

/// {@template authentication_state_stream}
/// Notifies when the authentication state changes
///
/// Emits:
/// - An [AuthenticationState]
/// {@endtemplate}
class AuthenticationStateStream {
  final AuthenticationRepository authenticationRepository;

  /// {@macro authentication_state_stream}
  const AuthenticationStateStream({required this.authenticationRepository});

  /// {@macro authentication_state_stream}
  Stream<AuthenticationState> call({required String serverUrl}) {
    return authenticationRepository.authenticationStateStream();
  }
}
