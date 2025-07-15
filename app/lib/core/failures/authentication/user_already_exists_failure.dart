import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

/// {@template user_already_exists_failure}
/// A class that represents user already exists failure.
/// {@endtemplate}
class UserAlreadyExistsFailure extends Failure {
/// {@macro user_already_exists_failure}
  const UserAlreadyExistsFailure()
    : super(
        name: 'User Already Exists',
        message: 'An account already with this information already exists.',
        categoryCode: FailureCategoryConstants.authentication,
        code: 'user_already_exists',
      );
}
