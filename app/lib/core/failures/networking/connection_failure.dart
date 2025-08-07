import 'package:location_history/core/failures/networking/network_failure.dart';

class ConnectionFailure extends NetworkFailure {
  ConnectionFailure({required super.serverType})
    : super(
        name: 'Connection Failure',
        message:
            'Failed to establish a connection with the ${serverType.name} server.',
        code: 'connection_failure',
      );
}
