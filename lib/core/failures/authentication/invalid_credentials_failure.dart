import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure()
    : super(
        name: "Invalid Credentials",
        message: "The email or password you entered is incorrect.",
        categoryCode: FailureCategoryConstants.authentication,
        code: "invalid_credentials",
      );
}
