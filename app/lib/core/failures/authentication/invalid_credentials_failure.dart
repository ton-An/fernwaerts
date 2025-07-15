import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

/// {@template invalid_credentials_failure}
/// A class that represents invalid credentials failure.
/// {@endtemplate}
class InvalidCredentialsFailure extends Failure {
/// {@macro invalid_credentials_failure}
  const InvalidCredentialsFailure()
    : super(
        name: 'Invalid Credentials',
        message: 'The email or password you entered is incorrect.',
        categoryCode: FailureCategoryConstants.authentication,
        code: 'invalid_credentials',
      );
}
