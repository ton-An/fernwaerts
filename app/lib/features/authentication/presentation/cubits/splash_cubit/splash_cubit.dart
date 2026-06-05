import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';
import 'package:location_history/features/authentication/domain/usecases/initialize_app.dart';
import 'package:location_history/features/authentication/domain/usecases/request_necessary_permissions.dart';
import 'package:location_history/features/authentication/presentation/cubits/splash_cubit/splash_state.dart';
import 'package:location_history/features/location_tracking/domain/usecases/init_background_location_tracking.dart';
import 'package:talker_flutter/talker_flutter.dart';

/*
  To-Do:
    - [ ] Add unit tests
    - [ ] Revisit permission handling if the permissions package exposes an
          awaitable result again.
    - [ ] Improve handling if there is server info in local storage but user
          isn't signed in (some unwanted services get initialized in that case)
*/

/// {@template splash_cubit}
/// Manages the application initialization flow including server connection,
/// authentication verification, permission requests, and location tracking setup.
///
/// Permission requests are triggered after authentication completes, but the
/// current permissions package returns before the user's response is available.
/// That means a permission failure can still be reported after the splash page
/// has already emitted [SplashAuthenticationComplete].
/// {@endtemplate}
class SplashCubit extends Cubit<SplashState> {
  /// {@macro splash_cubit}
  SplashCubit({
    required this.initializeApp,
    required this.requestNecessaryPermissions,
    required this.initBackgroundLocationTracking,
    required this.talker,
  }) : super(const SplashLoading());

  final InitializeApp initializeApp;
  final RequestNecessaryPermissions requestNecessaryPermissions;
  final InitBackgroundLocationTracking initBackgroundLocationTracking;
  final Talker talker;

  /// Initiates the app startup sequence and determines the initial application state.
  ///
  /// This method follows these steps:
  /// 1. Attempts to initialize any saved server connection
  /// 2. If successful, verifies user authentication
  /// 3. If authenticated, requests permissions and initializes location tracking
  ///
  /// The method will always emit either [SplashAuthenticationRequired] or
  /// [SplashAuthenticationComplete] as the authentication result. Additional
  /// [SplashFailure] states can still be emitted later while permission or
  /// background-tracking setup is running.
  ///
  /// Emits:
  /// - [SplashLoading] during initialization
  /// - [SplashAuthenticationRequired] if no server connection or not authenticated
  /// - [SplashAuthenticationComplete] if authentication is successful
  /// - [SplashFailure] if any errors occur during the process
  void determineInitialAppState() async {
    emit(const SplashLoading());

    final Either<Failure, None> initSavedConnectionEither =
        await initializeApp();

    initSavedConnectionEither.fold(
      (Failure failure) {
        talker.debug('Init saved server failed with Failure: $failure');

        emit(const SplashAuthenticationRequired());
      },
      (None none) async {
        talker.debug('Init saved server succeeded');
        emit(const SplashAuthenticationComplete());
        _requestNecessaryPermissions();
      },
    );
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
