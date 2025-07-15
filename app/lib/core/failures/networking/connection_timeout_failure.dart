import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

/// {@template connection_timeout_failure}
/// A class that represents connection timeout failure.
/// {@endtemplate}
class ConnectionTimeoutFailure extends Failure {
/// {@macro connection_timeout_failure}
  const ConnectionTimeoutFailure()
    : super(
        name: 'Connection Timeout',
        message: 'The connection timed out.',
        categoryCode: FailureCategoryConstants.networking,
        code: 'connection_timeout',
      );
}
