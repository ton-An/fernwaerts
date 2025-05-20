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
import 'package:location_history/features/authentication/presentation/pages/authentication_page/authentication_page.dart';
import 'package:location_history/features/location_tracking/domain/usecases/init_background_location_tracking.dart';

/* 
  To-Do:
    - [ ] Clean up toLogInInfo method (de-nest)
    - [ ] Look into simplifying states    
*/

/// {@template authentication_cubit}
/// Manages the entire authentication flow of the [AuthenticationPage]:
/// - Initializes and validates server connection.
/// - Routes to either admin sign-up or user sign-in.
/// - Requests platform permissions.
/// - Kicks off background location tracking.
/// {@endtemplate}
class AuthenticationCubit extends Cubit<AuthenticationCubitState> {
  /// {@macro authentication_cubit}
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

  late ServerInfo serverInfo;

  /// Emits [EnterServerDetails] to prompt the user to enter server details.
  ///
  /// Emits:
  /// - [EnterServerDetails]
  void toServerDetails() {
    emit(const EnterServerDetails());
  }

  /// Attempts to connect to the server using the provided [serverUrl]
  /// and checks if the server is set up.
  ///
  /// Emits:
  /// - [AuthenticationLoading] while processing
  /// - [EnterLogInInfo] if server is reachable and set up
  /// - [EnterAdminSignUpInfo] if server is reachable but not set up
  void toAuthDetails({required String serverUrl}) async {
    emit(const AuthenticationLoading());

    final Either<Failure, ServerInfo> isServerReachableEither =
        await initializeServerConnection(serverUrl: serverUrl);

    isServerReachableEither.fold(
      (Failure failure) {
        emit(AuthenticationFailure(failure: failure));
      },
      (ServerInfo serverInfo) async {
        this.serverInfo = serverInfo;

        _checkServerSetupStatus();
      },
    );
  }

  /// Sign up the initial admin with given credentials on the configured server.
  ///
  /// Emits:
  /// - [AuthenticationLoading] while processing
  /// - [AuthenticationSuccessful] if successful
  /// - [AuthenticationFailure] if an error occurs
  void signUpAdmin({
    required String username,
    required String email,
    required String password,
    required String repeatedPassword,
  }) async {
    emit(const AuthenticationLoading());

    final Either<Failure, None> signUpEither = await signUpInitialAdmin(
      serverInfo: serverInfo,
      username: username,
      email: email,
      password: password,
      repeatedPassword: repeatedPassword,
    );

    signUpEither.fold(
      (Failure failure) {
        emit(AuthenticationFailure(failure: failure));
      },
      (None none) async {
        _requestNecessaryPermissions();
      },
    );
  }

  /// Sign in an existing user with [email] and [password] on the configured server
  ///
  /// Emits:
  /// - [AuthenticationLoading] while processing
  /// - [AuthenticationSuccessful] if successful
  /// - [AuthenticationFailure] if an error occurs
  void signIn({required String email, required String password}) async {
    emit(const AuthenticationLoading());

    final Either<Failure, None> signInEither = await signInUsecase(
      serverInfo: serverInfo,
      email: email,
      password: password,
    );

    signInEither.fold(
      (Failure failure) {
        emit(AuthenticationFailure(failure: failure));
      },
      (None none) async {
        _requestNecessaryPermissions();
      },
    );
  }

  void _checkServerSetupStatus() async {
    final Either<Failure, bool> isServerSetUpEither = await isServerSetUp();

    isServerSetUpEither.fold(
      (Failure failure) {
        emit(AuthenticationFailure(failure: failure));
      },
      (bool isServerSetUp) {
        if (isServerSetUp) {
          emit(const EnterLogInInfo());
        } else {
          emit(const EnterAdminSignUpInfo());
        }
      },
    );
  }

  void _requestNecessaryPermissions() async {
    final Either<Failure, None> requestPermissionsEither =
        await requestNecessaryPermissions();

    requestPermissionsEither.fold(
      (Failure failure) {
        emit(AuthenticationFailure(failure: failure));
      },
      (None none) {
        _initBackgroundLocationTracking();
      },
    );
  }

  void _initBackgroundLocationTracking() async {
    final initTrackingEither = await initBackgroundLocationTracking();

    initTrackingEither.fold((Failure failure) {
      emit(AuthenticationFailure(failure: failure));
    }, (_) {});
  }
}
