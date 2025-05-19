import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/models/server_info.dart';
import 'package:location_history/features/authentication/domain/usecases/initialize_new_server_connection.dart';
import 'package:location_history/features/authentication/domain/usecases/is_server_set_up.dart';
import 'package:location_history/features/authentication/domain/usecases/request_necessary_permissions.dart';
import 'package:location_history/features/authentication/domain/usecases/sign_in.dart';
import 'package:location_history/features/authentication/domain/usecases/sign_up_initial_admin.dart';
import 'package:location_history/features/authentication/presentation/cubits/authentication_cubit/authentication_states.dart';
import 'package:location_history/features/location_tracking/domain/usecases/init_background_location_tracking.dart';

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
    required this.requestNecessaryPermissions,
    required this.initBackgroundLocationTracking,
  }) : super(const AuthenticationInitial());

  final InitializeNewServerConnection initializeServerConnection;
  final IsServerSetUp isServerSetUp;
  final SignUpInitialAdmin signUpInitialAdmin;
  final SignIn signInUsecase;
  final RequestNecessaryPermissions requestNecessaryPermissions;
  final InitBackgroundLocationTracking initBackgroundLocationTracking;

  String serverUrl = '';
  late ServerInfo serverInfo;

  void toServerDetails() {
    emit(const EnterServerDetails());
  }

  void toLogInInfo({required String serverUrl}) async {
    emit(const EnterServerDetailsLoading());

    final Either<Failure, ServerInfo> isServerReachableEither =
        await initializeServerConnection(serverUrl: serverUrl);

    isServerReachableEither.fold(
      (Failure failure) {
        emit(AuthenticationError(failure: failure));
      },
      (ServerInfo serverInfo) async {
        this.serverInfo = serverInfo;

        final Either<Failure, bool> isServerSetUpEither = await isServerSetUp();

        isServerSetUpEither.fold(
          (Failure failure) {
            emit(AuthenticationError(failure: failure));
          },
          (bool isServerSetUp) {
            this.serverUrl = serverUrl;

            if (isServerSetUp) {
              emit(const EnterLogInInfo());
            } else {
              emit(const EnterAdminSignUpInfo());
            }
          },
        );
      },
    );
  }

  void signUpAdmin({
    required String username,
    required String email,
    required String password,
    required String repeatedPassword,
  }) async {
    emit(const AdminSignUpLoading());

    final Either<Failure, None> signUpEither = await signUpInitialAdmin(
      serverInfo: serverInfo,
      username: username,
      email: email,
      password: password,
      repeatedPassword: repeatedPassword,
    );

    signUpEither.fold(
      (Failure failure) {
        emit(AuthenticationError(failure: failure));
      },
      (None none) async {
        final Either<Failure, None> requestPermissionsEither =
            await requestNecessaryPermissions();

        requestPermissionsEither.fold(
          (Failure failure) {
            emit(AuthenticationError(failure: failure));
            emit(const AdminSignUpSuccessful());
          },
          (None none) {
            emit(const AdminSignUpSuccessful());
          },
        );
      },
    );
  }

  void signIn({required String email, required String password}) async {
    emit(const LogInLoading());

    final Either<Failure, None> signInEither = await signInUsecase(
      serverInfo: serverInfo,
      email: email,
      password: password,
    );

    signInEither.fold(
      (Failure failure) {
        emit(AuthenticationError(failure: failure));
      },
      (None none) async {
        final Either<Failure, None> requestPermissionsEither =
            await requestNecessaryPermissions();

        requestPermissionsEither.fold((Failure failure) {
          emit(AuthenticationError(failure: failure));
        }, (None none) {});

        final initTrackingEither = await initBackgroundLocationTracking();

        initTrackingEither.fold(
          (Failure failure) {
            emit(AuthenticationError(failure: failure));
            emit(const LogInSuccessful());
          },
          (None none) {
            emit(const LogInSuccessful());
          },
        );
      },
    );
  }
}
