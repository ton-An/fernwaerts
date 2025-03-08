import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class UserNotFoundFailure extends Failure {
  const UserNotFoundFailure()
      : super(
          name: "User Not Found",
          message: "No user found with that email.",
          categoryCode: FailureCategoryConstants.authentication,
          code: "user_not_found",
        );
}
