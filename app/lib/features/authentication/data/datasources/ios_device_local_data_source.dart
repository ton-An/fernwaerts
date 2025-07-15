import 'package:device_info_plus/device_info_plus.dart';
import 'package:location_history/features/authentication/domain/enums/operating_system.dart';
import 'package:location_history/features/authentication/domain/models/raw_device.dart';

abstract class IOSDeviceLocalDataSource {
  const IOSDeviceLocalDataSource();

  /// Gets the device information of the current device
  ///
  /// Returns:
  /// - [RawDevice] the device information of the current device
  Future<RawDevice> getRawDeviceInfo();
}

/// {@template iosdevice_local_data_source_impl}
/// A class that represents iosdevice local data source impl.
/// {@endtemplate}
class IOSDeviceLocalDataSourceImpl implements IOSDeviceLocalDataSource {
/// {@macro iosdevice_local_data_source_impl}
  const IOSDeviceLocalDataSourceImpl({required this.deviceInfoPlugin});

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
