import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class NotAnAdminFailure extends Failure {
  const NotAnAdminFailure()
    : super(
        name: 'Not An Admin',
        message: 'The user is not an admin.',
        categoryCode: FailureCategoryConstants.authentication,
        code: 'not_an_admin',
      );
}
