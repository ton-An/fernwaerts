import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/core/failures/server_not_reachable_failure.dart';
import 'package:location_history/features/authentication/presentation/cubits/authentication_cubit/authentication_states.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());

  void continueToServerDetails() {
    emit(EnterServerDetails());
  }

  void continueToLogInInfo(String url) {
    emit(AuthenticationError(failure: ServerNotReachableFailure()));
    emit(EnterLogInInfo());
  }

  void logIn(String username, String password) {
    emit(LogInSuccessful());
  }
}
