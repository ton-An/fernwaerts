import 'package:location_history/core/failures/networking/network_failure.dart';

class BadResponseFailure extends NetworkFailure {
  BadResponseFailure({required super.serverType})
    : super(
        name: 'Invalid Response',
        message: 'The ${serverType.name} server returned an invalid response.',
        code: 'bad_response',
      );
}
