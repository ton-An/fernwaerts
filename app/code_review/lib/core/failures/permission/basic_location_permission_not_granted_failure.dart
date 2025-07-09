import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class BasicLocationPermissionNotGrantedFailure extends Failure {
  const BasicLocationPermissionNotGrantedFailure()
    : super(
        name: 'Basic Location Permission Not Granted',
        message: 'Permission to use location services has not been granted.',
        categoryCode: FailureCategoryConstants.permission,
        code: 'basic_location_permission_not_granted',
      );
}
