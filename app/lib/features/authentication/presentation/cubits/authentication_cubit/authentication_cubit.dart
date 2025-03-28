import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/usecases/initialize_server_connection.dart';
import 'package:location_history/features/authentication/domain/usecases/is_server_set_up.dart';
import 'package:location_history/features/authentication/presentation/cubits/authentication_cubit/authentication_states.dart';

/* 
  To-Do:
    - [ ] Clean up toLogInInfo method (de-nest)
*/

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit({
    required this.initializeServerConnection,
    required this.isServerSetUp,
  }) : super(AuthenticationInitial());

  final InitializeServerConnection initializeServerConnection;
  final IsServerSetUp isServerSetUp;

  void toServerDetails() {
    emit(EnterServerDetails());
  }

  void toLogInInfo(String serverUrl) async {
    emit(EnterServerDetailsLoading());

    final Either<Failure, None> isServerReachableEither =
        await initializeServerConnection(serverUrl: serverUrl);

    isServerReachableEither.fold(
      (Failure failure) {
        emit(AuthenticationError(failure: failure));
      },
      (None none) async {
        final Either<Failure, bool> isServerSetUpEither = await isServerSetUp();

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
