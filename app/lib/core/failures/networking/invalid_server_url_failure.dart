import 'package:location_history/core/failures/networking/network_failure.dart';

class InvalidUrlFormatFailure extends NetworkFailure {
  InvalidUrlFormatFailure({required super.serverType})
    : super(
        name: 'Invalid Server Url Format',
        message:
            'The ${serverType.name} server URL you entered is formatted incorrectly.',
        code: 'invalid_server_url_format',
      );
}
