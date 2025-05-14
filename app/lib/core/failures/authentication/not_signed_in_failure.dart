import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class NotSignedInFailure extends Failure {
  const NotSignedInFailure()
    : super(
        name: 'Not Signed In',
        message: 'The device is not signed in.',
        categoryCode: FailureCategoryConstants.authentication,
        code: 'not_signed_in',
      );
}
