import 'dart:async';
import 'dart:math';

import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:location_history/features/authentication/domain/repositories/device_repository.dart';
import 'package:location_history/features/authentication/domain/usecases/initialize_saved_server_connection.dart';
import 'package:location_history/features/location_tracking/domain/enums/activity_type.dart';
import 'package:location_history/features/location_tracking/domain/models/location.dart';
import 'package:location_history/features/location_tracking/domain/models/recorded_location.dart';
import 'package:location_history/features/location_tracking/domain/repositories/location_data_repository.dart';
import 'package:location_history/features/location_tracking/domain/repositories/location_tracking_repository.dart';

/* 
  To-Do:
    - [ ] Add activity and battery data
    - [ ] Maybe split usecase
    - [ ] Improve stationary device handling (e.g. app requests location when user walks around the house)
*/

class InitBackgroundLocationTracking {
  InitBackgroundLocationTracking({
    required this.initializeSavedServerConnection,
    required this.authenticationRepository,
    required this.deviceRepository,
    required this.locationTrackingRepository,
    required this.locationDataRepository,
  });

  final InitializeSavedServerConnection initializeSavedServerConnection;
  final AuthenticationRepository authenticationRepository;
  final DeviceRepository deviceRepository;
  final LocationTrackingRepository locationTrackingRepository;
  final LocationDataRepository locationDataRepository;

  Future<Either<Failure, None>> call() async {
    return _initServer();
  }

  Future<Either<Failure, None>> _initServer() async {
    final Either<Failure, None> initServerConnectionEither =
        await initializeSavedServerConnection();

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

    Timer? distanceFilterTimeout;

    locationStream.listen((RecordedLocation recordedLocation) async {
      final Location location = Location.fromRecordedLocation(
        recordedLocation: recordedLocation,
        userId: userId,
        deviceId: deviceId,
        activityType: ActivityType.unknown,
        activityConfidence: -1,
        batteryLevel: -1,
        isDeviceCharging: false,
      );

      distanceFilterTimeout = await _updateDistanceFilter(
        location: location,
        distanceFilterTimeout: distanceFilterTimeout,
      );
      await locationDataRepository.saveLocation(location: location);
    });
  }

  /// Updates the distance filter dynamically based on the device's current speed,
  /// and returns a timer that triggers a fallback re-initialization of location tracking
  /// if no location update is received within the expected time window.
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

  /// The curve of the distance filter starts off slow, then increases exponentially
  /// until it levels off at the maximum distance.
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
