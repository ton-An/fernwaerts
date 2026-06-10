import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/authentication/no_saved_device_failure.dart';
import 'package:location_history/core/failures/authentication/no_saved_server_failure.dart';
import 'package:location_history/core/failures/authentication/not_signed_in_failure.dart';
import 'package:location_history/core/failures/storage/storage_read_failure.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:location_history/features/authentication/domain/repositories/device_repository.dart';
import 'package:location_history/features/authentication/domain/usecases/initialize_app.dart';
import 'package:location_history/features/location_tracking/domain/models/location.dart';
import 'package:location_history/features/location_tracking/domain/models/recorded_location.dart';
import 'package:location_history/features/location_tracking/domain/repositories/battery_repository.dart';
import 'package:location_history/features/location_tracking/domain/repositories/location_data_repository.dart';
import 'package:location_history/features/location_tracking/domain/repositories/location_tracking_repository.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

/// {@template init_background_location_tracking}
/// Starts background location tracking for the signed-in user and current
/// device.
///
/// The use case initializes the saved server and sync connections, resolves the
/// current user and device IDs, starts the platform tracking service, listens
/// for raw location updates, converts them into persisted [Location] records,
/// and stores each record through [LocationDataRepository].
///
/// Failures:
/// - [StorageReadFailure]
/// - [NoSavedServerFailure]
/// - [NotSignedInFailure]
/// - [NoSavedDeviceFailure]
/// {@endtemplate}
class InitBackgroundLocationTracking {
  /// {@macro init_background_location_tracking}
  InitBackgroundLocationTracking({
    required this.initializeApp,
    required this.authenticationRepository,
    required this.deviceRepository,
    required this.locationTrackingRepository,
    required this.locationDataRepository,
    required this.batteryRepository,
  });

  final InitializeApp initializeApp;
  final AuthenticationRepository authenticationRepository;
  final DeviceRepository deviceRepository;
  final LocationTrackingRepository locationTrackingRepository;
  final LocationDataRepository locationDataRepository;
  final BatteryRepository batteryRepository;

  StreamSubscription<RecordedLocation>? _locationSubscription;

  /// {@macro init_background_location_tracking}
  Future<Either<Failure, None>> call() async {
    return _initServer();
  }

  Future<Either<Failure, None>> _initServer() async {
    final Either<Failure, None> initServerConnectionEither =
        await initializeApp();

    return initServerConnectionEither.fold(Left.new, (None none) {
      return _getUserId();
    });
  }

  Future<Either<Failure, None>> _getUserId() async {
    final Either<Failure, String> userIdEither =
        await authenticationRepository.getCurrentUserId();

    return userIdEither.fold(Left.new, (String userId) {
      return _getDeviceId(userId: userId);
    });
  }

  Future<Either<Failure, None>> _getDeviceId({required String userId}) async {
    final Either<Failure, String> deviceIdEither =
        await deviceRepository.getDeviceIdFromStorage();

    return deviceIdEither.fold(Left.new, (String deviceId) {
      return _initTracking(userId: userId, deviceId: deviceId);
    });
  }

  Future<Either<Failure, None>> _initTracking({
    required String userId,
    required String deviceId,
  }) async {
    await locationTrackingRepository.initTracking();

    _listenForLocationChanges(userId: userId, deviceId: deviceId);

    return const Right(None());
  }

  void _listenForLocationChanges({
    required String userId,
    required String deviceId,
  }) {
    final Stream<RecordedLocation> locationStream =
        locationTrackingRepository.locationChangeStream();

    _locationSubscription?.cancel();

    _locationSubscription = locationStream.listen((
      RecordedLocation recordedLocation,
    ) async {
      final Location location = Location.fromRecordedLocation(
        recordedLocation: recordedLocation,
        userId: userId,
        deviceId: deviceId,
      );

      await locationDataRepository.saveLocation(location: location);
    });
  }
}
