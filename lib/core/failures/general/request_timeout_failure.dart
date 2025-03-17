import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class RequestTimeoutFailure extends Failure {
  const RequestTimeoutFailure()
    : super(
        name: "Request Timeout",
        message: "The request timed out.",
        categoryCode: FailureCategoryConstants.general,
        code: "request_timeout",
      );
}
