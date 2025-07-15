import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

/// {@template password_mismatch_failure}
/// A class that represents password mismatch failure.
/// {@endtemplate}
class PasswordMismatchFailure extends Failure {
/// {@macro password_mismatch_failure}
  const PasswordMismatchFailure()
    : super(
        name: 'Password Mismatch',
        message: 'The provided passwords do not match.',
        categoryCode: FailureCategoryConstants.authentication,
        code: 'password_mismatch',
      );
}
