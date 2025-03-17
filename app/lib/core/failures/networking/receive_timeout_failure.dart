import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class ReceiveTimeoutFailure extends Failure {
  const ReceiveTimeoutFailure()
    : super(
        name: "Receive Timeout",
        message: "The server took too long to send data.",
        categoryCode: FailureCategoryConstants.networking,
        code: "receive_timeout",
      );
}
