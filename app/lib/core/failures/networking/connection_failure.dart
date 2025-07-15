import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

/// {@template connection_failure}
/// A class that represents connection failure.
/// {@endtemplate}
class ConnectionFailure extends Failure {
/// {@macro connection_failure}
  const ConnectionFailure()
    : super(
        name: 'Connection Failure',
        message: 'Failed to establish a connection with the server.',
        categoryCode: FailureCategoryConstants.networking,
        code: 'connection_failure',
      );
}
