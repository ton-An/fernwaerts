import 'package:webfabrik_theme/webfabrik_theme.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class NoSavedDeviceFailure extends Failure {
  const NoSavedDeviceFailure()
    : super(
        name: 'No Saved Device',
        message: 'No saved device could be found.',
        categoryCode: FailureCategoryConstants.authentication,
        code: 'no_saved_device',
      );
}
