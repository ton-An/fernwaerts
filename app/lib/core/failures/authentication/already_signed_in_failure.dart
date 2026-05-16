import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class AlreadySignedInFailure extends Failure {
  const AlreadySignedInFailure()
    : super(
        name: 'Already Signed In',
        message: 'You are already signed in. Please sign out and try again.',
        categoryCode: FailureCategoryConstants.authentication,
        code: 'already_signed_in',
      );
}
