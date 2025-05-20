import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/authentication/no_saved_server_failure.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/usecases/initialize_saved_server_connection.dart';
import 'package:location_history/features/authentication/domain/usecases/is_signed_in.dart';
import 'package:location_history/features/authentication/domain/usecases/request_necessary_permissions.dart';
import 'package:location_history/features/authentication/presentation/cubits/splash_cubit/splash_states.dart';
import 'package:location_history/features/location_tracking/domain/usecases/init_background_location_tracking.dart';

/// {@template splash_cubit}
/// Manages the application initialization flow including server connection,
/// authentication verification, permission requests, and location tracking setup.
/// {@endtemplate}
class SplashCubit extends Cubit<SplashState> {
  /// {@macro splash_cubit}
  SplashCubit({
    required this.initSavedServerConnection,
    required this.isSignedInUsecase,
    required this.requestNecessaryPermissions,
    required this.initBackgroundLocationTracking,
  }) : super(const SplashLoading());

  final InitializeSavedServerConnection initSavedServerConnection;
  final IsSignedIn isSignedInUsecase;
  final RequestNecessaryPermissions requestNecessaryPermissions;
  final InitBackgroundLocationTracking initBackgroundLocationTracking;

  /// Initiates the app startup sequence and determines the initial application state.
  ///
  /// This method follows these steps:
  /// 1. Attempts to initialize any saved server connection
  /// 2. If successful, verifies user authentication
  /// 3. If authenticated, requests permissions and initializes location tracking
  ///
  /// The method will always emit either [SplashAuthenticationRequired] or
  /// [SplashAuthenticationComplete] as the final state. The [SplashFailure]s
  /// main purpose is to display errors to the user.
  ///
  /// Emits:
  /// - [SplashLoading] during initialization
  /// - [SplashAuthenticationRequired] if no server connection or not authenticated
  /// - [SplashAuthenticationComplete] if authentication is successful
  /// - [SplashFailure] if any errors occur during the process
  void determineInitialAppState() async {
    emit(const SplashLoading());

    final Either<Failure, None> initSavedConnectionEither =
        await initSavedServerConnection();

    initSavedConnectionEither.fold(_handleConnectionFailure, (None none) async {
      _checkAuthentication();
    });
  }

  void _handleConnectionFailure(Failure failure) {
    if (failure is! NoSavedServerFailure) {
      emit(SplashFailure(failure: failure));
    }

    emit(const SplashAuthenticationRequired());
  }

  void _checkAuthentication() async {
    bool isSignedIn = await isSignedInUsecase();

    if (isSignedIn) {
      emit(const SplashAuthenticationComplete());
      _requestNecessaryPermissions();
    } else {
      emit(const SplashAuthenticationRequired());
    }
  }

  void _requestNecessaryPermissions() async {
    final Either<Failure, None> requestPermissionsEither =
        await requestNecessaryPermissions();

    requestPermissionsEither.fold(
      (Failure failure) {
        emit(SplashFailure(failure: failure));
      },
      (None none) {
        _initBackgroundLocationTracking();
      },
    );
  }

  void _initBackgroundLocationTracking() async {
    final initTrackingEither = await initBackgroundLocationTracking();

    initTrackingEither.fold((Failure failure) {
      emit(SplashFailure(failure: failure));
    }, (_) {});
  }
}
