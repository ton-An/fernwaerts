import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

/// {@template no_saved_device_failure}
/// A class that represents no saved device failure.
/// {@endtemplate}
class NoSavedDeviceFailure extends Failure {
/// {@macro no_saved_device_failure}
  const NoSavedDeviceFailure()
    : super(
        name: 'No Saved Device',
        message: 'No saved device could be found.',
        categoryCode: FailureCategoryConstants.authentication,
        code: 'no_saved_device',
      );
}
