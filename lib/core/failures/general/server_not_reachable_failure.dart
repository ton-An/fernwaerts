import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class ServerNotReachableFailure extends Failure {
  const ServerNotReachableFailure()
      : super(
          name: "Server Not Reachable",
          message: "The server is not reachable.",
          categoryCode: FailureCategoryConstants.general,
          code: "server_not_reachable",
        );
}
