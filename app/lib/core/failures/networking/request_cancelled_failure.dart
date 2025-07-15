import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

/// {@template request_cancelled_failure}
/// A class that represents request cancelled failure.
/// {@endtemplate}
class RequestCancelledFailure extends Failure {
/// {@macro request_cancelled_failure}
  const RequestCancelledFailure()
    : super(
        name: 'Request Cancelled',
        message: 'The network request was cancelled.',
        categoryCode: FailureCategoryConstants.networking,
        code: 'request_cancelled',
      );
}
