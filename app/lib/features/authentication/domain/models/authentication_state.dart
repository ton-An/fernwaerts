abstract class AuthenticationState {}

/// {@template signed_in_state}
/// A state class that represents signedin state.
/// {@endtemplate}
class SignedInState extends AuthenticationState {}

/// {@template signed_out_state}
/// A state class that represents signedout state.
/// {@endtemplate}
class SignedOutState extends AuthenticationState {}
