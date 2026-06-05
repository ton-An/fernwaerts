import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';
import 'package:location_history/features/authentication/domain/models/supabase_info.dart';
import 'package:location_history/features/authentication/domain/usecases/initialize_new_supabase_connection.dart';
import 'package:location_history/features/authentication/domain/usecases/is_server_set_up.dart';
import 'package:location_history/features/authentication/domain/usecases/request_necessary_permissions.dart';
import 'package:location_history/features/authentication/domain/usecases/sign_in.dart';
import 'package:location_history/features/authentication/domain/usecases/sign_up_initial_admin.dart';
import 'package:location_history/features/authentication/presentation/cubits/authentication_cubit/authentication_state.dart';
import 'package:location_history/features/authentication/presentation/pages/authentication_page/authentication_page.dart';
import 'package:location_history/features/location_tracking/domain/usecases/init_background_location_tracking.dart';

/*
  To-Do:
    - [ ] Add tests
    - [ ] Track permission request failures once the permissions package exposes
          an awaitable result again.
*/

/// {@template authentication_cubit}
/// Manages the entire authentication flow of the [AuthenticationPage]:
/// - Initializes and validates server connection.
/// - Routes to either admin sign-up or user sign-in.
/// - Requests platform permissions, but currently cannot await the user's
///   response because the permission plugin returns before the dialog result is
///   available.
/// - Kicks off background location tracking.
/// {@endtemplate}
class AuthenticationCubit extends Cubit<AuthenticationState> {
  /// {@macro authentication_cubit}
  AuthenticationCubit({
    required this.initializeNewSupabaseConnection,
    required this.isServerSetUp,
    required this.signUpInitialAdmin,
    required this.signInUsecase,
    required this.requestNecessaryPermissions,
    required this.initBackgroundLocationTracking,
  }) : super(const AuthenticationInitial());

  final InitializeNewSupabaseConnection initializeNewSupabaseConnection;
  final IsServerSetUp isServerSetUp;
  final SignUpInitialAdmin signUpInitialAdmin;
  final SignIn signInUsecase;
  final RequestNecessaryPermissions requestNecessaryPermissions;
  final InitBackgroundLocationTracking initBackgroundLocationTracking;

  late SupabaseInfo supabaseInfo;

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
  /// - [EnterLoginInfo] if server is reachable and set up
  /// - [EnterAdminSignUpInfo] if server is reachable but not set up
  void toAuthDetails({required String serverUrl}) async {
    emit(const AuthenticationLoading());

    final Either<Failure, SupabaseInfo> initializeNewSupabaseConnectionEither =
        await initializeNewSupabaseConnection(serverUrl: serverUrl);

    initializeNewSupabaseConnectionEither.fold(
      (Failure failure) {
        emit(AuthenticationFailure(failure: failure));
      },
      (SupabaseInfo supabaseInfo) async {
        this.supabaseInfo = supabaseInfo;

        _checkServerSetupStatus();
      },
    );
  }

  /// Sign up the initial admin with given credentials on the configured server.
  ///
  /// Emits:
  /// - [AuthenticationLoading] while processing
  /// - [AuthenticationSuccess] if successful
  /// - [AuthenticationFailure] if an error occurs
  ///
  /// The permissions request that follows success is started immediately and
  /// cannot currently surface its own result because the permission plugin
  /// resolves before the user response is available.
  void signUpAdmin({
    required String username,
    required String email,
    required String password,
    required String repeatedPassword,
  }) async {
    emit(const AuthenticationLoading());

    final Either<Failure, None> signUpEither = await signUpInitialAdmin(
      supabaseInfo: supabaseInfo,
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
        emit(const AuthenticationSuccess());
        _requestNecessaryPermissions();
      },
    );
  }

  /// Sign in an existing user with [email] and [password] on the configured server
  ///
  /// Emits:
  /// - [AuthenticationLoading] while processing
  /// - [AuthenticationSuccess] if successful
  /// - [AuthenticationFailure] if an error occurs
  ///
  /// The permissions request that follows success is started immediately and
  /// cannot currently surface its own result because the permission plugin
  /// resolves before the user response is available.
  void signIn({required String email, required String password}) async {
    emit(const AuthenticationLoading());

    final Either<Failure, None> signInEither = await signInUsecase(
      supabaseInfo: supabaseInfo,
      email: email,
      password: password,
    );

    signInEither.fold(
      (Failure failure) {
        emit(AuthenticationFailure(failure: failure));
      },
      (None none) async {
        emit(const AuthenticationSuccess());
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
          emit(const EnterLoginInfo());
        } else {
          emit(const EnterAdminSignUpInfo());
        }
      },
    );
  }

  void _requestNecessaryPermissions() async {
    final Either<Failure, None> requestPermissionsEither =
        await requestNecessaryPermissions();

    requestPermissionsEither.fold((Failure failure) {
      emit(AuthenticationFailure(failure: failure));
    }, (_) {});
  }
}
