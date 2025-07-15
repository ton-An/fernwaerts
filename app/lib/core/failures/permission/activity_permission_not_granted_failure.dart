import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

/// {@template activity_permission_not_granted_failure}
/// A class that represents activity permission not granted failure.
/// {@endtemplate}
class ActivityPermissionNotGrantedFailure extends Failure {
/// {@macro activity_permission_not_granted_failure}
  const ActivityPermissionNotGrantedFailure()
    : super(
        name: 'Activity Permission Not Granted',
        message:
            'Permission to use activity recognition services has not been granted.',
        categoryCode: FailureCategoryConstants.permission,
        code: 'activity_permission_not_granted',
      );
}
