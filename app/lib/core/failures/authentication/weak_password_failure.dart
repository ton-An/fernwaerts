import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

/// {@template weak_password_failure}
/// A class that represents weak password failure.
/// {@endtemplate}
class WeakPasswordFailure extends Failure {
/// {@macro weak_password_failure}
  const WeakPasswordFailure()
    : super(
        name: 'Weak Password',
        message:
            'The password is too weak. It needs at least 8 characters, 1 uppercase letter, 1 lowercase letter, 1 number, and 1 special character.',
        categoryCode: FailureCategoryConstants.authentication,
        code: 'weak_password',
      );
}
