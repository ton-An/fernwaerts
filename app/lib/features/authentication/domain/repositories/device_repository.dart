import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/authentication/device_info_platform_not_supported_failure.dart';
import 'package:location_history/core/failures/authentication/no_saved_device_failure.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';
import 'package:location_history/core/failures/storage/storage_read_failure.dart';
import 'package:location_history/core/failures/storage/storage_write_failure.dart';
import 'package:location_history/features/authentication/domain/models/device.dart';
import 'package:location_history/features/authentication/domain/models/raw_device.dart';

/// {@template device_repository}
/// Domain contract for device metadata and persisted installation identity.
///
/// Callers should use this contract to read device metadata, persist the
/// user-scoped device record, and store the generated Fernwaerts device id.
/// {@endtemplate}
abstract class DeviceRepository {
  /// {@macro device_repository}
  const DeviceRepository();

  /// Gets the device's information
  ///
  /// Returns:
  /// - a [RawDevice] object containing the device's information.
  ///
  /// Failures:
  /// - [DeviceInfoPlatformNotSupportedFailure]
  Future<Either<Failure, RawDevice>> getRawDeviceInfo();

  /// Saves the user-scoped device information to the database.
  ///
  /// Parameters:
  /// - device: [Device] object to save
  Future<void> saveDeviceInfoToDB({required Device device});

  /// Saves the generated Fernwaerts device id to local storage.
  ///
  /// Parameters:
  /// - deviceId: [String] id of the device to save
  ///
  /// Failures:
  /// - [StorageWriteFailure]
  Future<Either<Failure, None>> saveDeviceIdToStorage({
    required String deviceId,
  });

  /// Gets the generated Fernwaerts device id from local storage.
  ///
  /// Returns:
  /// - a [String] containing the device's id.
  ///
  /// Failures:
  /// - [StorageReadFailure]
  /// - [NoSavedDeviceFailure]
  Future<Either<Failure, String>> getDeviceIdFromStorage();

  /// Gets the app version installed on this device.
  ///
  /// Returns:
  /// - a [String] containing the app version.
  String getAppVersion();
}
