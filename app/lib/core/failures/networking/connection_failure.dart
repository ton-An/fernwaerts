import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class ConnectionFailure extends Failure {
  const ConnectionFailure()
    : super(
        name: 'Connection Failure',
        message: 'Failed to establish a connection with the server.',
        categoryCode: FailureCategoryConstants.networking,
        code: 'connection_failure',
      );
}
