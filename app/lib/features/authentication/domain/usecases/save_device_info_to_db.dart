import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/authentication/device_info_platform_not_supported_failure.dart';
import 'package:location_history/core/failures/authentication/not_signed_in_failure.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/authentication/domain/models/device.dart';
import 'package:location_history/features/authentication/domain/models/raw_device.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:location_history/features/authentication/domain/repositories/device_repository.dart';

/// {@template save_device_info_to_db}
/// Saves the device's information to the database.
///
/// Failures:
/// - [NotSignedInFailure]
/// - [DeviceInfoPlatformNotSupportedFailure]
/// {@endtemplate}
class SaveDeviceInfo {
  /// {@macro save_device_info_to_db}
  const SaveDeviceInfo({
    required this.authenticationRepository,
    required this.deviceRepository,
  });

  final DeviceRepository deviceRepository;
  final AuthenticationRepository authenticationRepository;

  /// {@macro save_device_info_to_db}
  Future<Either<Failure, None>> call() {
    return _getUserId();
  }

  Future<Either<Failure, None>> _getUserId() async {
    final Either<Failure, String> userIdEither =
        await authenticationRepository.getCurrentUserId();

    return userIdEither.fold(
      Left.new,
      (String userId) => _getAppVersion(userId: userId),
    );
  }

  Future<Either<Failure, None>> _getAppVersion({required String userId}) {
    final String appVersion = deviceRepository.getAppVersion();

    return _getRawDeviceInfo(userId: userId, appVersion: appVersion);
  }

  Future<Either<Failure, None>> _getRawDeviceInfo({
    required String userId,
    required String appVersion,
  }) async {
    final Either<Failure, RawDevice> rawDeviceEither =
        await deviceRepository.getRawDeviceInfo();

    return rawDeviceEither.fold(
      Left.new,
      (RawDevice rawDevice) => _saveDeviceInfoToDB(
        userId: userId,
        appVersion: appVersion,
        rawDevice: rawDevice,
      ),
    );
  }

  Future<Either<Failure, None>> _saveDeviceInfoToDB({
    required String userId,
    required String appVersion,
    required RawDevice rawDevice,
  }) async {
    final Device device = Device.fromRawDevice(
      rawDevice: rawDevice,
      appVersion: appVersion,
      userId: userId,
    );

    await deviceRepository.saveDeviceInfoToDB(device: device);

    return _saveDeviceIdToStorage(deviceId: device.id);
  }

  Future<Either<Failure, None>> _saveDeviceIdToStorage({
    required String deviceId,
  }) {
    return deviceRepository.saveDeviceIdToStorage(deviceId: deviceId);
  }
}
