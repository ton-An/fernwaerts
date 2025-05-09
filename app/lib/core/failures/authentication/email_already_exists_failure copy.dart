import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class DeviceInfoPlatformNotSupported extends Failure {
  const DeviceInfoPlatformNotSupported()
    : super(
        name: 'Device Info Platform Not Supported',
        message: "Getting the device's info is not supported on this platform.",
        categoryCode: FailureCategoryConstants.authentication,
        code: 'device_info_platform_not_supported',
      );
}
