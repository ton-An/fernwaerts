import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class EmailRateLimitFailure extends Failure {
  const EmailRateLimitFailure()
    : super(
        name: 'Sending E-Mail failed',
        message: 'You have sent too many emails. Please try again in a bit.',
        categoryCode: FailureCategoryConstants.authentication,
        code: 'email_rate_limit',
      );
}
