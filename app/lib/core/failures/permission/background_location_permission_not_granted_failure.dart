import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

/// {@template background_location_permission_not_granted_failure}
/// A class that represents background location permission not granted failure.
/// {@endtemplate}
class BackgroundLocationPermissionNotGrantedFailure extends Failure {
/// {@macro background_location_permission_not_granted_failure}
  const BackgroundLocationPermissionNotGrantedFailure()
    : super(
        name: 'Background Location Permission Not Granted',
        message:
            'Permission to use background location services has not been granted.',
        categoryCode: FailureCategoryConstants.permission,
        code: 'background_location_permission_not_granted',
      );
}
