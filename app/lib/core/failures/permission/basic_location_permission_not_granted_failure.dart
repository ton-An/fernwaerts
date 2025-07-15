import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

/// {@template basic_location_permission_not_granted_failure}
/// A class that represents basic location permission not granted failure.
/// {@endtemplate}
class BasicLocationPermissionNotGrantedFailure extends Failure {
/// {@macro basic_location_permission_not_granted_failure}
  const BasicLocationPermissionNotGrantedFailure()
    : super(
        name: 'Basic Location Permission Not Granted',
        message: 'Permission to use location services has not been granted.',
        categoryCode: FailureCategoryConstants.permission,
        code: 'basic_location_permission_not_granted',
      );
}
