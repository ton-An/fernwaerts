import 'package:location_history/core/failures/networking/network_failure.dart';

class RequestCancelledFailure extends NetworkFailure {
  RequestCancelledFailure({required super.serverType})
    : super(
        name: 'Request Cancelled',
        message:
            'The network request to the ${serverType.name} server was cancelled.',
        code: 'request_cancelled',
      );
}
