import 'package:location_history/core/failures/networking/network_failure.dart';

class ConnectionTimeoutFailure extends NetworkFailure {
  ConnectionTimeoutFailure({required super.serverType})
    : super(
        name: 'Connection Timeout',
        message: 'The connection to the ${serverType.name} server timed out.',
        code: 'connection_timeout',
      );
}
