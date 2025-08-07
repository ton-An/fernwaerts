import 'package:location_history/core/failures/networking/network_failure.dart';

class UnknownRequestFailure extends NetworkFailure {
  UnknownRequestFailure({required super.serverType})
    : super(
        name: 'Unknown Request Failure',
        message:
            'The request to the ${serverType.name} server failed for an unknown reason',
        code: 'unknown_request_failure',
      );
}
