import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/dependency_injector.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:location_history/features/authentication/domain/repositories/device_repository.dart';
import 'package:location_history/features/authentication/domain/usecases/initialize_app.dart';
import 'package:location_history/features/location_tracking/domain/models/location.dart'
    as domain;
import 'package:location_history/features/location_tracking/domain/models/recorded_location.dart';
import 'package:location_history/features/location_tracking/domain/repositories/location_data_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:tracelet/tracelet.dart' as tracelet;
import 'package:webfabrik_theme/webfabrik_theme.dart';

/// Tracelet headless entry point for iOS background relaunches.
///
/// The callback must stay top-level so Tracelet can look it up from the
/// background isolate. Location payloads are persisted through the normal app
/// repository after resolving the current user and device from local storage.
@pragma('vm:entry-point')
void traceletHeadlessTask(tracelet.HeadlessEvent event) {
  if (event.name != 'location') {
    return;
  }

  unawaited(_persistHeadlessLocation(event));
}

Future<void> _persistHeadlessLocation(tracelet.HeadlessEvent event) async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    _initHeadlessDependencies();

    await getIt.isReady<PackageInfo>();

    final Either<Failure, None> initEither = await getIt<InitializeApp>()();
    await initEither.match((Failure failure) async {}, (None none) async {
      final Either<Failure, String> userIdEither =
          await getIt<AuthenticationRepository>().getCurrentUserId();

      await userIdEither.match((Failure failure) async {}, (
        String userId,
      ) async {
        final Either<Failure, String> deviceIdEither =
            await getIt<DeviceRepository>().getDeviceIdFromStorage();

        await deviceIdEither.match((Failure failure) async {}, (
          String deviceId,
        ) async {
          final tracelet.Location traceletLocation = tracelet.Location.fromMap(
            event.event,
          );
          final RecordedLocation recordedLocation =
              RecordedLocation.fromTraceletLocation(
                traceletLocation: traceletLocation,
              );
          final domain.Location location = domain.Location.fromRecordedLocation(
            recordedLocation: recordedLocation,
            userId: userId,
            deviceId: deviceId,
          );

          await getIt<LocationDataRepository>().saveLocation(
            location: location,
          );
        });
      });
    });
  } catch (exception, stackTrace) {
    if (getIt.isRegistered<Talker>()) {
      getIt<Talker>().handle(
        exception,
        stackTrace,
        'Tracelet headless location persistence failed',
      );
    }
  }
}

void _initHeadlessDependencies() {
  if (!getIt.isRegistered<InitializeApp>()) {
    initGetIt();
  }
}
