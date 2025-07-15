import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

/// {@template not_signed_in_failure}
/// A class that represents not signed in failure.
/// {@endtemplate}
class NotSignedInFailure extends Failure {
/// {@macro not_signed_in_failure}
  const NotSignedInFailure()
    : super(
        name: 'Not Signed In',
        message: 'The device is not signed in.',
        categoryCode: FailureCategoryConstants.authentication,
        code: 'not_signed_in',
      );
}
