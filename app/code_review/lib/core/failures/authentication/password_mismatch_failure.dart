import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class PasswordMismatchFailure extends Failure {
  const PasswordMismatchFailure()
    : super(
        name: 'Password Mismatch',
        message: 'The provided passwords do not match.',
        categoryCode: FailureCategoryConstants.authentication,
        code: 'password_mismatch',
      );
}
