import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class UnknownRequestFailure extends Failure {
  const UnknownRequestFailure()
    : super(
        name: 'Unknown Request Failure',
        message: 'The request failed for an unknown reason',
        categoryCode: FailureCategoryConstants.networking,
        code: 'unknown_request_failure',
      );
}
