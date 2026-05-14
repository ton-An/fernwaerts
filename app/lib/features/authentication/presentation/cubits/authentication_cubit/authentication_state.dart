import 'package:location_history/core/failures/failure.dart';

/// {@template authentication_state}
/// Base state for the server setup, sign-in, and initial admin sign-up flow.
/// {@endtemplate}
abstract class AuthenticationState {
  /// {@macro authentication_state}
  const AuthenticationState();
}

/// {@template authentication_initial}
/// Initial authentication flow state before the user starts setup.
/// {@endtemplate}
class AuthenticationInitial extends AuthenticationState {
  /// {@macro authentication_initial}
  const AuthenticationInitial();
}

/// {@template authentication_loading}
/// Indicates that the current authentication step is running.
/// {@endtemplate}
class AuthenticationLoading extends AuthenticationState {
  /// {@macro authentication_loading}
  const AuthenticationLoading();
}

/// {@template enter_server_details}
/// Requests the server URL before the app can choose the next auth step.
/// {@endtemplate}
class EnterServerDetails extends AuthenticationState {
  /// {@macro enter_server_details}
  const EnterServerDetails();
}

/// {@template enter_login_info}
/// Requests credentials for an already initialized server.
/// {@endtemplate}
class EnterLoginInfo extends AuthenticationState {
  /// {@macro enter_login_info}
  const EnterLoginInfo();
}

/// {@template enter_admin_sign_up_info}
/// Requests initial admin account details for a server without setup data.
/// {@endtemplate}
class EnterAdminSignUpInfo extends AuthenticationState {
  /// {@macro enter_admin_sign_up_info}
  const EnterAdminSignUpInfo();
}

/// {@template authentication_success}
/// Indicates that sign-in or initial admin sign-up completed successfully.
/// {@endtemplate}
class AuthenticationSuccess extends AuthenticationState {
  /// {@macro authentication_success}
  const AuthenticationSuccess();
}

/// {@template authentication_failure}
/// Carries a recoverable [failure] from the active authentication step.
/// {@endtemplate}
class AuthenticationFailure extends AuthenticationState {
  /// {@macro authentication_failure}
  const AuthenticationFailure({required this.failure});

  /// Failure displayed to the user by the auth page listener.
  final Failure failure;
}
