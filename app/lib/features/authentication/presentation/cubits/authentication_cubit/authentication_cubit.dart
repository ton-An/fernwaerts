import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/usecases/check_if_server_set_up.dart';
import 'package:location_history/features/authentication/domain/usecases/check_server_reachability.dart';
import 'package:location_history/features/authentication/presentation/cubits/authentication_cubit/authentication_states.dart';

/* 
  To-Do:
    - [ ] Clean up toLogInInfo method (de-nest)
*/

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit({
    required this.checkServerReachability,
    required this.checkIfServerSetUp,
  }) : super(AuthenticationInitial());

  final CheckServerReachability checkServerReachability;
  final CheckIfServerSetUp checkIfServerSetUp;

  void toServerDetails() {
    emit(EnterServerDetails());
  }

  void toLogInInfo(String serverUrl) async {
    emit(EnterServerDetailsLoading());

    final Either<Failure, None> reachabilityCheckEither =
        await checkServerReachability(serverUrl: Uri.parse(serverUrl));

    reachabilityCheckEither.fold(
      (Failure failure) {
        emit(AuthenticationError(failure: failure));
      },
      (None none) async {
        final Either<Failure, bool> isServerSetUpEither =
            await checkIfServerSetUp(serverUrl: Uri.parse(serverUrl));

        isServerSetUpEither.fold(
          (Failure failure) {
            emit(AuthenticationError(failure: failure));
          },
          (bool isServerSetUp) {
            if (isServerSetUp) {
              emit(EnterLogInInfo());
            } else {
              emit(EnterAdminSignUpInfo());
            }
          },
        );
      },
    );
  }

  void signUpAdmin(
    String username,
    String email,
    String password,
    String confirmPassword,
  ) {
    emit(AdminSignUpSuccessful());
  }

  void logIn(String username, String password) {
    emit(LogInSuccessful());
  }
}
