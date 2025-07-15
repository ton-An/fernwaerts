import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

/// {@template unexpected_authentication_failure}
/// A class that represents unexpected authentication failure.
/// {@endtemplate}
class UnexpectedAuthenticationFailure extends Failure {
/// {@macro unexpected_authentication_failure}
  const UnexpectedAuthenticationFailure()
    : super(
        name: 'Unexpected Authentication Error',
        message: 'An unexpected error occurred during authentication.',
        categoryCode: FailureCategoryConstants.authentication,
        code: 'unexpected_authentication_error',
      );
}
