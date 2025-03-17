import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class ConnectionTimeoutFailure extends Failure {
  const ConnectionTimeoutFailure()
    : super(
        name: "Connection Timeout",
        message: "The connection timed out.",
        categoryCode: FailureCategoryConstants.networking,
        code: "connection_timeout",
      );
}
