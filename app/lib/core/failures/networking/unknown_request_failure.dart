import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

/// {@template unknown_request_failure}
/// A class that represents unknown request failure.
/// {@endtemplate}
class UnknownRequestFailure extends Failure {
/// {@macro unknown_request_failure}
  const UnknownRequestFailure()
    : super(
        name: 'Unknown Request Failure',
        message: 'The request failed for an unknown reason',
        categoryCode: FailureCategoryConstants.networking,
        code: 'unknown_request_failure',
      );
}
