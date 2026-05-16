/// {@template authentication_state}
/// Base domain event for changes to the user's authenticated session.
/// {@endtemplate}
abstract class AuthenticationState {
  /// {@macro authentication_state}
  const AuthenticationState();
}

/// {@template signed_in_state}
/// Indicates that the auth provider has an active signed-in session.
/// {@endtemplate}
class SignedInState extends AuthenticationState {
  /// {@macro signed_in_state}
  const SignedInState();
}

/// {@template signed_out_state}
/// Indicates that there is no active signed-in session.
/// {@endtemplate}
class SignedOutState extends AuthenticationState {
  /// {@macro signed_out_state}
  const SignedOutState();
}
