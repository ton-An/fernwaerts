import 'dart:async';
import 'dart:math';

import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/authentication/no_saved_device_failure.dart';
import 'package:location_history/core/failures/authentication/no_saved_server_failure.dart';
import 'package:location_history/core/failures/authentication/not_signed_in_failure.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';
import 'package:location_history/core/failures/storage/storage_read_failure.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:location_history/features/authentication/domain/repositories/device_repository.dart';
import 'package:location_history/features/authentication/domain/usecases/initialize_app.dart';
import 'package:location_history/features/location_tracking/domain/models/battery_status.dart';
import 'package:location_history/features/location_tracking/domain/models/location.dart';
import 'package:location_history/features/location_tracking/domain/models/recognized_activity.dart';
import 'package:location_history/features/location_tracking/domain/models/recorded_location.dart';
import 'package:location_history/features/location_tracking/domain/repositories/battery_repository.dart';
import 'package:location_history/features/location_tracking/domain/repositories/location_data_repository.dart';
import 'package:location_history/features/location_tracking/domain/repositories/location_tracking_repository.dart';

/// {@template init_background_location_tracking}
/// Starts background location tracking for the signed-in user and current
/// device.
///
/// The use case initializes the saved server and sync connections, resolves the
/// current user and device IDs, starts the platform tracking service, listens
/// for raw location updates, converts them into persisted [Location] records,
/// and stores each record through [LocationDataRepository].
///
/// It also updates the platform distance filter after every recorded location.
/// Faster movement increases the filter distance, while stationary or
/// zero-speed updates keep a conservative default and schedule a delayed
/// tracking re-initialization.
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
  StreamSubscription<RecognizedActivity>? _activitySubscription;
  RecognizedActivity _latestActivity = RecognizedActivity.unknown;

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
    final Stream<RecognizedActivity> activityStream =
        locationTrackingRepository.activityChangeStream();

    Timer? distanceFilterTimeout;

    _locationSubscription?.cancel();
    _activitySubscription?.cancel();
    _latestActivity = RecognizedActivity.unknown;

    _activitySubscription = activityStream.listen((
      RecognizedActivity activity,
    ) {
      _latestActivity = activity;
    });

    _locationSubscription = locationStream.listen((
      RecordedLocation recordedLocation,
    ) async {
      final BatteryStatus batteryStatus =
          await batteryRepository.getBatteryStatus();

      final Location location = Location.fromRecordedLocation(
        recordedLocation: recordedLocation,
        userId: userId,
        deviceId: deviceId,
        activityType: _latestActivity.type,
        activityConfidence: _latestActivity.confidence,
        batteryLevel: batteryStatus.level,
        isDeviceCharging: batteryStatus.isDeviceCharging,
      );

      distanceFilterTimeout = await _updateDistanceFilter(
        location: location,
        distanceFilterTimeout: distanceFilterTimeout,
      );
      await locationDataRepository.saveLocation(location: location);
    });
  }

  /// Updates the platform distance filter based on the current speed.
  ///
  /// Returns:
  /// - [Timer] that re-initializes tracking when no location update arrives
  ///   inside the expected time window
  Future<Timer> _updateDistanceFilter({
    required Location location,
    required Timer? distanceFilterTimeout,
  }) async {
    distanceFilterTimeout?.cancel();

    final double speedInMetersPerSecond = location.speed.toDouble();

    late final double distanceFilterInMeters;
    late final double secondsUntilFilterTimeout;

    if (speedInMetersPerSecond <= 0.0) {
      distanceFilterInMeters = 500;
      secondsUntilFilterTimeout = 1000;
    } else {
      distanceFilterInMeters = _calculateDistanceFilter(
        speedInMetersPerSecond: speedInMetersPerSecond,
      );

      secondsUntilFilterTimeout =
          distanceFilterInMeters / speedInMetersPerSecond * 1.5;
    }

    Timer newDistanceFilterTimeout = Timer(
      Duration(seconds: secondsUntilFilterTimeout.ceil()),
      () async {
        await locationTrackingRepository.initTracking();
      },
    );

    await locationTrackingRepository.updateDistanceFilter(
      distanceFilter: distanceFilterInMeters,
    );

    return newDistanceFilterTimeout;
  }

  /// Calculates a speed-sensitive distance filter in meters.
  ///
  /// The curve starts slowly, increases exponentially, then levels off near the
  /// maximum distance so high-speed travel records fewer points.
  double _calculateDistanceFilter({required double speedInMetersPerSecond}) {
    final double speedInKmh = speedInMetersPerSecond * 3.6;

    const double maxDistanceInMeters = 10000;
    const double growthFactor = 0.008;
    const double levelOffFactor = 2.2;

    return maxDistanceInMeters *
            pow(1 - pow(e, -growthFactor * speedInKmh), levelOffFactor) +
        100;
  }
}
