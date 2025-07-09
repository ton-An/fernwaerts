import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class InvalidUrlFormatFailure extends Failure {
  const InvalidUrlFormatFailure()
    : super(
        name: 'Invalid Server Url Format',
        message: 'The server URL you entered is formatted incorrectly.',
        categoryCode: FailureCategoryConstants.networking,
        code: 'invalid_server_url_format',
      );
}
