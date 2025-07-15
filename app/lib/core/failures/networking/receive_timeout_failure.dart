import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

/// {@template receive_timeout_failure}
/// A class that represents receive timeout failure.
/// {@endtemplate}
class ReceiveTimeoutFailure extends Failure {
/// {@macro receive_timeout_failure}
  const ReceiveTimeoutFailure()
    : super(
        name: 'Receive Timeout',
        message: 'The server took too long to send data.',
        categoryCode: FailureCategoryConstants.networking,
        code: 'receive_timeout',
      );
}
