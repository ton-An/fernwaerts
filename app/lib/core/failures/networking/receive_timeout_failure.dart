import 'package:location_history/core/failures/networking/network_failure.dart';

class ReceiveTimeoutFailure extends NetworkFailure {
  ReceiveTimeoutFailure({required super.serverType})
    : super(
        name: 'Receive Timeout',
        message: 'The ${serverType.name} server took too long to send data.',
        code: 'receive_timeout',
      );
}
