import 'package:location_history/core/failures/failure.dart';

abstract class AuthenticationCubitState {
  const AuthenticationCubitState();
}

/// {@template authentication_initial}
/// A class that represents authentication initial.
/// {@endtemplate}
class AuthenticationInitial extends AuthenticationCubitState {
/// {@macro authentication_initial}
  const AuthenticationInitial();
}

/// {@template authentication_loading}
/// A class that represents authentication loading.
/// {@endtemplate}
class AuthenticationLoading extends AuthenticationCubitState {
/// {@macro authentication_loading}
  const AuthenticationLoading();
}

/// {@template enter_server_details}
/// A class that represents enter server details.
/// {@endtemplate}
class EnterServerDetails extends AuthenticationCubitState {
/// {@macro enter_server_details}
  const EnterServerDetails();
}

/// {@template enter_log_in_info}
/// A class that represents enter log in info.
/// {@endtemplate}
class EnterLogInInfo extends AuthenticationCubitState {
/// {@macro enter_log_in_info}
  const EnterLogInInfo();
}

/// {@template enter_admin_sign_up_info}
/// A class that represents enter admin sign up info.
/// {@endtemplate}
class EnterAdminSignUpInfo extends AuthenticationCubitState {
/// {@macro enter_admin_sign_up_info}
  const EnterAdminSignUpInfo();
}

/// {@template authentication_successful}
/// A class that represents authentication successful.
/// {@endtemplate}
class AuthenticationSuccessful extends AuthenticationCubitState {
/// {@macro authentication_successful}
  const AuthenticationSuccessful();
}

/// {@template authentication_failure}
/// A class that represents authentication failure.
/// {@endtemplate}
class AuthenticationFailure extends AuthenticationCubitState {
/// {@macro authentication_failure}
  const AuthenticationFailure({required this.failure});

  final Failure failure;
}
