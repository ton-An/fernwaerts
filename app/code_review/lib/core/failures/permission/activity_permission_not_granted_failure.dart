import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class ActivityPermissionNotGrantedFailure extends Failure {
  const ActivityPermissionNotGrantedFailure()
    : super(
        name: 'Activity Permission Not Granted',
        message:
            'Permission to use activity recognition services has not been granted.',
        categoryCode: FailureCategoryConstants.permission,
        code: 'activity_permission_not_granted',
      );
}
