import 'package:device_info_plus/device_info_plus.dart';
import 'package:location_history/features/authentication/domain/enums/operating_system.dart';
import 'package:location_history/features/authentication/domain/models/raw_device.dart';

/// {@template android_device_local_data_source}
/// Android device data source contract for platform-provided device metadata.
/// {@endtemplate}
abstract class AndroidDeviceLocalDataSource {
  /// {@macro android_device_local_data_source}
  const AndroidDeviceLocalDataSource();

  /// Gets raw Android device information for registration.
  ///
  /// Returns:
  /// - [RawDevice] containing device, OS, and manufacturer metadata
  Future<RawDevice> getRawDeviceInfo();
}

class AndroidDeviceLocalDataSourceImpl implements AndroidDeviceLocalDataSource {
  const AndroidDeviceLocalDataSourceImpl({required this.deviceInfoPlugin});

  final DeviceInfoPlugin deviceInfoPlugin;

  @override
  Future<RawDevice> getRawDeviceInfo() async {
    final AndroidDeviceInfo androidDeviceInfo =
        await deviceInfoPlugin.androidInfo;

    return RawDevice(
      name: androidDeviceInfo.name,
      model: androidDeviceInfo.model,
      manufacturer: androidDeviceInfo.brand,
      os: OperatingSystem.android,
      osVersion: androidDeviceInfo.version.release,
    );
  }
}
