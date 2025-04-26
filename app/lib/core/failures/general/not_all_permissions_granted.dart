import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class NotAllPermissionsGrantedFailure extends Failure {
  const NotAllPermissionsGrantedFailure()
    : super(
        name: 'Not all permissions granted',
        message: 'Not all required permissions have been granted',
        categoryCode: FailureCategoryConstants.general,
        code: 'not_all_permissions_granted',
      );
}
