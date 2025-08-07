import 'package:location_history/core/failures/networking/network_failure.dart';

class StatusCodeNotOkFailure extends NetworkFailure {
  StatusCodeNotOkFailure({required super.serverType, required int statusCode})
    : super(
        name: 'Status Code Not OK',
        message:
            'The returned status code from the ${serverType.name} server is $statusCode',
        code: 'status_code_not_ok',
      );
}
