import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class PasswordMustDifferFailure extends Failure {
  const PasswordMustDifferFailure()
    : super(
        name: 'Password must differ',
        message: 'The new password must be different from the old one.',
        categoryCode: FailureCategoryConstants.authentication,
        code: 'password_must_differ',
      );
}
