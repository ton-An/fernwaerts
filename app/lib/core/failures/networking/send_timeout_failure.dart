import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class SendTimeoutFailure extends Failure {
  const SendTimeoutFailure()
    : super(
        name: 'Send Timeout',
        message: 'The request took too long to send.',
        categoryCode: FailureCategoryConstants.networking,
        code: 'send_timeout',
      );
}
