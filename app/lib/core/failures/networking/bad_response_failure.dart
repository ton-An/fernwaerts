import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

/// {@template bad_response_failure}
/// A class that represents bad response failure.
/// {@endtemplate}
class BadResponseFailure extends Failure {
/// {@macro bad_response_failure}
  const BadResponseFailure()
    : super(
        name: 'Invalid Response',
        message: 'The server returned an invalid response.',
        categoryCode: FailureCategoryConstants.networking,
        code: 'bad_response',
      );
}
