import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class DeviceInfoPlatformNotSupportedFailure extends Failure {
  const DeviceInfoPlatformNotSupportedFailure()
    : super(
        name: 'Device Info Platform Not Supported',
        message: "Getting the device's info is not supported on this platform.",
        categoryCode: FailureCategoryConstants.authentication,
        code: 'device_info_platform_not_supported',
      );
}
