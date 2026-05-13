import 'package:location_history/core/failures/failure.dart';

/// {@template authentication_cubit_state}
/// Base state for the server setup, sign-in, and initial admin sign-up flow.
/// {@endtemplate}
abstract class AuthenticationCubitState {
  /// {@macro authentication_cubit_state}
  const AuthenticationCubitState();
}

/// {@template authentication_initial}
/// Initial authentication flow state before the user starts setup.
/// {@endtemplate}
class AuthenticationInitial extends AuthenticationCubitState {
  /// {@macro authentication_initial}
  const AuthenticationInitial();
}

/// {@template authentication_loading}
/// Indicates that the current authentication step is running.
/// {@endtemplate}
class AuthenticationLoading extends AuthenticationCubitState {
  /// {@macro authentication_loading}
  const AuthenticationLoading();
}

/// {@template enter_server_details}
/// Requests the server URL before the app can choose the next auth step.
/// {@endtemplate}
class EnterServerDetails extends AuthenticationCubitState {
  /// {@macro enter_server_details}
  const EnterServerDetails();
}

/// {@template enter_log_in_info}
/// Requests credentials for an already initialized server.
/// {@endtemplate}
class EnterLogInInfo extends AuthenticationCubitState {
  /// {@macro enter_log_in_info}
  const EnterLogInInfo();
}

/// {@template enter_admin_sign_up_info}
/// Requests initial admin account details for a server without setup data.
/// {@endtemplate}
class EnterAdminSignUpInfo extends AuthenticationCubitState {
  /// {@macro enter_admin_sign_up_info}
  const EnterAdminSignUpInfo();
}

/// {@template authentication_successful}
/// Indicates that sign-in or initial admin sign-up completed successfully.
/// {@endtemplate}
class AuthenticationSuccessful extends AuthenticationCubitState {
  /// {@macro authentication_successful}
  const AuthenticationSuccessful();
}

/// {@template authentication_failure}
/// Carries a recoverable [failure] from the active authentication step.
/// {@endtemplate}
class AuthenticationFailure extends AuthenticationCubitState {
  /// {@macro authentication_failure}
  const AuthenticationFailure({required this.failure});

  /// Failure displayed to the user by the auth page listener.
  final Failure failure;
}
