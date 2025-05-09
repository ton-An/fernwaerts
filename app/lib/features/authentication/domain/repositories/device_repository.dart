import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/authentication/device_info_platform_not_supported_failure.dart';
import 'package:location_history/core/failures/authentication/no_saved_device_failure.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/storage/storage_read_failure.dart';
import 'package:location_history/core/failures/storage/storage_write_failure.dart';
import 'package:location_history/features/authentication/domain/models/device.model.dart';
import 'package:location_history/features/authentication/domain/models/raw_device.dart';

abstract class DeviceRepository {
  /// Gets the device's information
  ///
  /// Returns:
  /// - a [RawDevice] object containing the device's information.
  ///
  /// Failures:
  /// - [DeviceInfoPlatformNotSupportedFailure]
  Future<Either<Failure, RawDevice>> getRawDeviceInfo();

  /// Saves the device's information to the database
  ///
  /// Parameters:
  /// - [Device] device: The device object to save.
  Future<void> saveDeviceInfoToDB({required Device device});

  /// Save the device's id to storage
  ///
  /// Parameters:
  /// - [String] deviceId: The id of the device to save.
  ///
  /// Failures:
  /// - [StorageWriteFailure]
  Future<Either<Failure, None>> saveDeviceIdToStorage({
    required String deviceId,
  });

  /// Gets the device's id from storage
  ///
  /// Returns:
  /// - a [String] containing the device's id.
  ///
  /// Failures:
  /// - [StorageReadFailure]
  /// - [NoSavedDeviceFailure]
  Future<Either<Failure, String>> getDeviceIdFromStorage();
}
