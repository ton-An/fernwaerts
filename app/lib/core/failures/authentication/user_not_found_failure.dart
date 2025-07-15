import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

/// {@template user_not_found_failure}
/// A class that represents user not found failure.
/// {@endtemplate}
class UserNotFoundFailure extends Failure {
/// {@macro user_not_found_failure}
  const UserNotFoundFailure()
    : super(
        name: 'User Not Found',
        message: 'No user found with that email.',
        categoryCode: FailureCategoryConstants.authentication,
        code: 'user_not_found',
      );
}
