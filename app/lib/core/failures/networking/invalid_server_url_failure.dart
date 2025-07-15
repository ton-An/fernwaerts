import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

/// {@template invalid_url_format_failure}
/// A class that represents invalid url format failure.
/// {@endtemplate}
class InvalidUrlFormatFailure extends Failure {
/// {@macro invalid_url_format_failure}
  const InvalidUrlFormatFailure()
    : super(
        name: 'Invalid Server Url Format',
        message: 'The server URL you entered is formatted incorrectly.',
        categoryCode: FailureCategoryConstants.networking,
        code: 'invalid_server_url_format',
      );
}
