import 'package:device_info_plus/device_info_plus.dart';
import 'package:location_history/features/authentication/domain/enums/operating_system.dart';
import 'package:location_history/features/authentication/domain/models/raw_device.dart';

abstract class AndroidDeviceLocalDataSource {
  const AndroidDeviceLocalDataSource();

  /// Gets the device information of the current device
  ///
  /// Returns:
  /// - [RawDevice] the device information of the current device
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
