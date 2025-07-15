import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

/// {@template email_already_exists_failure}
/// A class that represents email already exists failure.
/// {@endtemplate}
class EmailAlreadyExistsFailure extends Failure {
/// {@macro email_already_exists_failure}
  const EmailAlreadyExistsFailure()
    : super(
        name: 'Email Already Exists',
        message: 'The email address is already in use.',
        categoryCode: FailureCategoryConstants.authentication,
        code: 'email_already_exists',
      );
}
