import 'package:location_history/core/failures/failure.dart';

// part 'authentication_states.freezed.dart';

abstract class AuthenticationCubitState {
  const AuthenticationCubitState();
}

class AuthenticationInitial extends AuthenticationCubitState {
  const AuthenticationInitial();
}

class EnterServerDetails extends AuthenticationCubitState {
  const EnterServerDetails();
}

class EnterServerDetailsLoading extends AuthenticationCubitState {
  const EnterServerDetailsLoading();
}

class EnterLogInInfo extends AuthenticationCubitState {
  const EnterLogInInfo();
}

class EnterAdminSignUpInfo extends AuthenticationCubitState {
  const EnterAdminSignUpInfo();
}

class LogInSuccessful extends AuthenticationCubitState {
  const LogInSuccessful();
}

class AdminSignUpSuccessful extends AuthenticationCubitState {
  const AdminSignUpSuccessful();
}

class AdminSignUpLoading extends AuthenticationCubitState {
  const AdminSignUpLoading();
}

class AuthenticationError extends AuthenticationCubitState {
  const AuthenticationError({required this.failure});

  final Failure failure;
}
