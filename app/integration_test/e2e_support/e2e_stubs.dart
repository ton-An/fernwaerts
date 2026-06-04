import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/dependency_injector.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/in_app_notification/presentation/cubit/in_app_notification_cubit.dart';
import 'package:location_history/features/location_tracking/domain/usecases/init_background_location_tracking.dart';

/// E2E test wiring.
///
/// iOS permission dialogs are handled outside of Dart: `app/tool/run_e2e.sh`
/// watches for the app install and runs `simctl privacy grant` so the real
/// permission_handler / CLLocationManager calls return granted without a
/// prompt.
///
/// The two swaps below are about *test isolation*, not permissions:
///
///   - [InAppNotificationCubit] is re-registered as a lazy singleton so the
///     instance [MainApp]'s `BlocProvider` uses is the same one the test
///     reaches via `getIt`. With the production factory registration the test
///     would otherwise dismiss a brand-new (empty) cubit and the active
///     notification would still cover the widget the next step wants to tap.
///   - [InitBackgroundLocationTracking] is replaced with a no-op because the
///     cubit fires it as fire-and-forget after every successful sign-in. The
///     real implementation opens a PowerSync SQLite connection that easily
///     outlives the next sign-out; the next sign-in then races the stale
///     instance on the same database file and the SharedMutex deadlocks. This
///     is a real bug in production sign-out / sign-in cycles, but it surfaces
///     here because the e2e suite runs several cycles back-to-back.
void registerE2EStubs() {
  if (getIt.isRegistered<InAppNotificationCubit>()) {
    getIt.unregister<InAppNotificationCubit>();
  }
  getIt.registerLazySingleton<InAppNotificationCubit>(
    () => InAppNotificationCubit(),
  );

  if (getIt.isRegistered<InitBackgroundLocationTracking>()) {
    getIt.unregister<InitBackgroundLocationTracking>();
  }
  getIt.registerLazySingleton<InitBackgroundLocationTracking>(
    () => _NoopInitBackgroundLocationTracking(
      initializeApp: getIt(),
      authenticationRepository: getIt(),
      deviceRepository: getIt(),
      locationTrackingRepository: getIt(),
      locationDataRepository: getIt(),
      batteryRepository: getIt(),
    ),
  );
}

class _NoopInitBackgroundLocationTracking
    extends InitBackgroundLocationTracking {
  _NoopInitBackgroundLocationTracking({
    required super.initializeApp,
    required super.authenticationRepository,
    required super.deviceRepository,
    required super.locationTrackingRepository,
    required super.locationDataRepository,
    required super.batteryRepository,
  });

  @override
  Future<Either<Failure, None>> call() async => const Right(None());
}

/// Clears any visible in-app notification so subsequent taps don't hit the
/// notification's pointer-absorbing overlay. Safe to call when no
/// notification is showing — the cubit's null-check on its internal queue
/// would otherwise throw.
void dismissActiveNotification() {
  try {
    getIt<InAppNotificationCubit>().dismissNotification();
  } catch (_) {
    // No active notification; nothing to dismiss.
  }
}
