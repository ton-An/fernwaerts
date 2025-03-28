import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class EmailAddressInvalidFailure extends Failure {
  const EmailAddressInvalidFailure()
    : super(
        name: 'Invalid Email Address',
        message: 'The email address is not valid.',
        categoryCode: FailureCategoryConstants.authentication,
        code: 'email_address_invalid',
      );
}
