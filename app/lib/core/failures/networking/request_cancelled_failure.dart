import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class RequestCancelledFailure extends Failure {
  const RequestCancelledFailure()
    : super(
        name: "Request Cancelled",
        message: "The network request was cancelled.",
        categoryCode: FailureCategoryConstants.networking,
        code: "request_cancelled",
      );
}
