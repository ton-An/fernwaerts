import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class BackgroundLocationPermissionNotGrantedFailure extends Failure {
  const BackgroundLocationPermissionNotGrantedFailure()
    : super(
        name: 'Background Location Permission Not Granted',
        message:
            'Permission to use background location services has not been granted.',
        categoryCode: FailureCategoryConstants.permission,
        code: 'background_location_permission_not_granted',
      );
}
