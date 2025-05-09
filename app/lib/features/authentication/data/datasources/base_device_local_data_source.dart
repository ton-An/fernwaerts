import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:location_history/core/failures/authentication/no_saved_device_failure.dart';

abstract class BaseDeviceLocalDataSource {
  const BaseDeviceLocalDataSource();

  /// Gets the current device's id from storage
  ///
  /// Returns:
  /// - [String] the device id
  ///
  /// Throws:
  /// - [PlatformException]
  /// - [NoSavedDeviceFailure]
  Future<String> getDeviceIdFromStorage();

  /// Saves the device's id to storage
  ///
  /// Parameters:
  /// - [String] deviceId: the id of the device to save.
  ///
  /// Throws:
  /// - [PlatformException]
  Future<void> saveDeviceIdToStorage({required String deviceId});
}

class BaseDeviceLocalDataSourceImpl extends BaseDeviceLocalDataSource {
  const BaseDeviceLocalDataSourceImpl({required this.secureStorage});

  final FlutterSecureStorage secureStorage;

  static const _deviceIdStorageKey = 'device_id';

  @override
  Future<String> getDeviceIdFromStorage() async {
    final String? deviceId = await secureStorage.read(key: _deviceIdStorageKey);

    if (deviceId == null) {
      throw const NoSavedDeviceFailure();
    }

    return deviceId;
  }

  @override
  Future<void> saveDeviceIdToStorage({required String deviceId}) async {
    await secureStorage.write(key: _deviceIdStorageKey, value: deviceId);
  }
}
