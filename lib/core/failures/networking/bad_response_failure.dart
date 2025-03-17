import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class BadResponseFailure extends Failure {
  const BadResponseFailure()
    : super(
        name: "Invalid Response",
        message: "The server returned an invalid response.",
        categoryCode: FailureCategoryConstants.networking,
        code: "bad_response",
      );
}
