import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

/// {@template send_timeout_failure}
/// A class that represents send timeout failure.
/// {@endtemplate}
class SendTimeoutFailure extends Failure {
/// {@macro send_timeout_failure}
  const SendTimeoutFailure()
    : super(
        name: 'Send Timeout',
        message: 'The request took too long to send.',
        categoryCode: FailureCategoryConstants.networking,
        code: 'send_timeout',
      );
}
