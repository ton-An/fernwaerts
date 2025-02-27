import 'package:location_history/core/failures/failure.dart';

// @freezed
class ServerNotReachableFailure extends Failure {
  const ServerNotReachableFailure()
      : super(
          name: "Server Not Reachable",
          message: "The server is not reachable",
          categoryCode: "general",
          code: "server_not_reachable",
        );
}
