import 'package:device_info_plus/device_info_plus.dart';
import 'package:location_history/features/authentication/domain/enums/operating_system.dart';
import 'package:location_history/features/authentication/domain/models/device.model.dart';
import 'package:location_history/features/authentication/domain/models/raw_device.dart';

abstract class IosDeviceLocalDataSource {
  const IosDeviceLocalDataSource();

  /// Gets the device information of the current device
  ///
  /// Returns:
  /// - [Device] the device information of the current device
  ///
  /// Throws:
  /// - TBD
  Future<RawDevice> getRawDeviceInfo();
}

class IosDeviceLocalDataSourceImpl implements IosDeviceLocalDataSource {
  const IosDeviceLocalDataSourceImpl({required this.deviceInfoPlugin});

  final DeviceInfoPlugin deviceInfoPlugin;

  @override
  Future<RawDevice> getRawDeviceInfo() async {
    final IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;

    final RawDevice rawDevice = RawDevice(
      name: iosDeviceInfo.name,
      model: iosDeviceInfo.modelName,
      manufacturer: 'Apple',
      os: OperatingSystem.ios,
      osVersion: iosDeviceInfo.systemVersion,
    );

    return rawDevice;
  }
}
