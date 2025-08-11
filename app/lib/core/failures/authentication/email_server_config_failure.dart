import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class EmailServerConfigFailure extends Failure {
  const EmailServerConfigFailure()
    : super(
        name: 'Sending E-Mail failed',
        message: 'This is likely due to a misconfigured email server.',
        categoryCode: FailureCategoryConstants.authentication,
        code: 'email_server_config',
      );
}
