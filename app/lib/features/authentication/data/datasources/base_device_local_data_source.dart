import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';
import 'package:location_history/core/failures/authentication/no_saved_device_failure.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// {@template base_device_local_data_source}
/// Shared local device data source contract for persisted device identity.
///
/// Platform-specific data sources provide raw device metadata; this contract
/// owns the stable app-generated device id and app version.
/// {@endtemplate}
abstract class BaseDeviceLocalDataSource {
  /// {@macro base_device_local_data_source}
  const BaseDeviceLocalDataSource();

  /// Gets the current device id from secure storage.
  ///
  /// Returns:
  /// - [String] the saved device id
  ///
  /// Throws:
  /// - [PlatformException]
  /// - [NoSavedDeviceFailure]
  Future<String> getDeviceIdFromStorage();

  /// Saves the current device id to secure storage.
  ///
  /// Parameters:
  /// - deviceId: [String] device id to save
  ///
  /// Throws:
  /// - [PlatformException]
  Future<void> saveDeviceIdToStorage({required String deviceId});

  /// Gets the installed app version.
  ///
  /// Returns:
  /// - [String] app version from package metadata
  String getAppVersion();
}

class BaseDeviceLocalDataSourceImpl extends BaseDeviceLocalDataSource {
  const BaseDeviceLocalDataSourceImpl({
    required this.secureStorage,
    required this.packageInfo,
  });

  final FlutterSecureStorage secureStorage;
  final PackageInfo packageInfo;

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

  @override
  String getAppVersion() {
    return packageInfo.version;
  }
}
