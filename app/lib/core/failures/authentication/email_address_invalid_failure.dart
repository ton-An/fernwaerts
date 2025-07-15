import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

/// {@template email_address_invalid_failure}
/// A class that represents email address invalid failure.
/// {@endtemplate}
class EmailAddressInvalidFailure extends Failure {
/// {@macro email_address_invalid_failure}
  const EmailAddressInvalidFailure()
    : super(
        name: 'Invalid Email Address',
        message: 'The email address is not valid.',
        categoryCode: FailureCategoryConstants.authentication,
        code: 'email_address_invalid',
      );
}
