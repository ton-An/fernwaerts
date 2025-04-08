import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/usecases/initialize_server_connection.dart';
import 'package:location_history/features/authentication/domain/usecases/is_server_set_up.dart';
import 'package:location_history/features/authentication/domain/usecases/sign_in.dart';
import 'package:location_history/features/authentication/domain/usecases/sign_up_initial_admin.dart';
import 'package:location_history/features/authentication/presentation/cubits/authentication_cubit/authentication_states.dart';

/* 
  To-Do:
    - [ ] Clean up toLogInInfo method (de-nest)
    - [ ] Add loading indicators to widgets
    - [ ] Look into simplifying states    
*/

class AuthenticationCubit extends Cubit<AuthenticationCubitState> {
  AuthenticationCubit({
    required this.initializeServerConnection,
    required this.isServerSetUp,
    required this.signUpInitialAdmin,
    required this.signInUsecase,
  }) : super(AuthenticationInitial());

  final InitializeServerConnection initializeServerConnection;
  final IsServerSetUp isServerSetUp;
  final SignUpInitialAdmin signUpInitialAdmin;
  final SignIn signInUsecase;

  String serverUrl = '';

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
            this.serverUrl = serverUrl;

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
    String repeatedPassword,
  ) async {
    emit(AdminSignUpLoading());

    final Either<Failure, None> signUpEither = await signUpInitialAdmin(
      serverUrl: serverUrl,
      username: username,
      email: email,
      password: password,
      repeatedPassword: repeatedPassword,
    );

    signUpEither.fold(
      (Failure failure) {
        emit(AuthenticationError(failure: failure));
      },
      (None none) {
        emit(AdminSignUpSuccessful());
      },
    );
  }

  void signIn(String email, String password) async {
    emit(LogInLoading());

    final Either<Failure, None> signInEither = await signInUsecase(
      email: email,
      password: password,
      serverUrl: serverUrl,
    );

    signInEither.fold(
      (Failure failure) {
        emit(AuthenticationError(failure: failure));
      },
      (None none) {
        emit(LogInSuccessful());
      },
    );
  }
}
