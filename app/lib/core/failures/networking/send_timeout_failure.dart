import 'package:location_history/core/failures/networking/network_failure.dart';

class SendTimeoutFailure extends NetworkFailure {
  SendTimeoutFailure({required super.serverType})
    : super(
        name: 'Send Timeout',
        message:
            'The request to the ${serverType.name} server took too long to send.',
        code: 'send_timeout',
      );
}
