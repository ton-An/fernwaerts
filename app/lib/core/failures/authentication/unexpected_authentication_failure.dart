import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class UnexpectedAuthenticationFailure extends Failure {
  const UnexpectedAuthenticationFailure()
    : super(
        name: "Unexpected Authentication Error",
        message: "An unexpected error occurred during authentication.",
        categoryCode: FailureCategoryConstants.authentication,
        code: "unexpected_authentication_error",
      );
}
