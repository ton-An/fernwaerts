// Stream of significant location changes
// Includes:
// - Starting/stopping fine grained tracking
//     - Use activity data to save battery
// - should get the current location if the activity is still

import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:location_history/features/authentication/domain/usecases/initialize_saved_server_connection.dart';
import 'package:location_history/features/location_tracking/domain/models/location.model.dart';
import 'package:location_history/features/location_tracking/domain/models/recorded_location.dart';
import 'package:location_history/features/location_tracking/domain/repositories/location_data_repository.dart';
import 'package:location_history/features/location_tracking/domain/repositories/location_tracking_repository.dart';

class InitBackgroundLocationTracking {
  InitBackgroundLocationTracking({
    required this.authenticationRepository,
    required this.locationTrackingRepository,
    required this.locationDataRepository,
    required this.initializeSavedServerConnection,
  });

  final AuthenticationRepository authenticationRepository;
  final LocationTrackingRepository locationTrackingRepository;
  final LocationDataRepository locationDataRepository;
  final InitializeSavedServerConnection initializeSavedServerConnection;

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
        await authenticationRepository.getCurrentDeviceId();

    return deviceIdEither.fold(Left.new, (String deviceId) {
      return _initTracking(userId: userId, deviceId: deviceId);
    });
  }

  Future<Either<Failure, None>> _initTracking({
    required String userId,
    required String deviceId,
  }) async {
    final Either<Failure, None> initEither =
        await locationTrackingRepository.initTracking();

    return initEither.fold(Left.new, (None none) {
      _listenForLocationChanges(userId: userId, deviceId: deviceId);

      return const Right(None());
    });
  }

  void _listenForLocationChanges({
    required String userId,
    required String deviceId,
  }) {
    final Stream<RecordedLocation> locationStream =
        locationTrackingRepository.locationChangeStream();

    locationStream.listen((RecordedLocation recordedLocation) {
      final Location location = Location.fromRecordedLocation(
        recordedLocation: recordedLocation,
        userId: userId,
        deviceId: deviceId,
      );

      locationDataRepository.saveLocation(location: location);
    });
  }
}
