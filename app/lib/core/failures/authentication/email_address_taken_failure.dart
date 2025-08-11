import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class EmailAddressTakenFailure extends Failure {
  const EmailAddressTakenFailure()
    : super(
        name: 'Email Address Taken',
        message: 'The email address is already taken.',
        categoryCode: FailureCategoryConstants.authentication,
        code: 'email_address_taken',
      );
}
