import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class LocationPermissionNotGrantedFailure extends Failure {
  const LocationPermissionNotGrantedFailure()
    : super(
        name: 'Location Permission Not Granted',
        message: 'Permission to use location services has not been granted.',
        categoryCode: FailureCategoryConstants.permission,
        code: 'location_permission_not_granted',
      );
}
