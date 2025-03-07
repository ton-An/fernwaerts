import 'package:location_history/core/failures/failure.dart';

// part 'authentication_states.freezed.dart';

abstract class AuthenticationState {
  const AuthenticationState();
}

class AuthenticationInitial extends AuthenticationState {
  const AuthenticationInitial();
}

class EnterServerDetails extends AuthenticationState {
  const EnterServerDetails();
}

class EnterLogInInfo extends AuthenticationState {
  const EnterLogInInfo();
}

class EnterAdminSignUpInfo extends AuthenticationState {
  const EnterAdminSignUpInfo();
}

class LogInSuccessful extends AuthenticationState {
  const LogInSuccessful();
}

class AdminSignUpSuccessful extends AuthenticationState {
  const AdminSignUpSuccessful();
}

class AuthenticationError extends AuthenticationState {
  const AuthenticationError({
    required this.failure,
  });

  final Failure failure;
}
