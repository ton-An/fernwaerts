import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class UserAlreadyExistsFailure extends Failure {
  const UserAlreadyExistsFailure()
    : super(
        name: 'User Already Exists',
        message: 'An account already with this information already exists.',
        categoryCode: FailureCategoryConstants.authentication,
        code: 'user_already_exists',
      );
}
