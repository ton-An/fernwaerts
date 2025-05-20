import 'package:location_history/core/failures/failure.dart';

abstract class AuthenticationCubitState {
  const AuthenticationCubitState();
}

class AuthenticationInitial extends AuthenticationCubitState {
  const AuthenticationInitial();
}

class AuthenticationLoading extends AuthenticationCubitState {
  const AuthenticationLoading();
}

class EnterServerDetails extends AuthenticationCubitState {
  const EnterServerDetails();
}

class EnterLogInInfo extends AuthenticationCubitState {
  const EnterLogInInfo();
}

class EnterAdminSignUpInfo extends AuthenticationCubitState {
  const EnterAdminSignUpInfo();
}

class AuthenticationSuccessful extends AuthenticationCubitState {
  const AuthenticationSuccessful();
}

class AuthenticationFailure extends AuthenticationCubitState {
  const AuthenticationFailure({required this.failure});

  final Failure failure;
}
