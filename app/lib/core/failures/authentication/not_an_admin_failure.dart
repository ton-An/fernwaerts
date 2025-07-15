import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

/// {@template not_an_admin_failure}
/// A class that represents not an admin failure.
/// {@endtemplate}
class NotAnAdminFailure extends Failure {
/// {@macro not_an_admin_failure}
  const NotAnAdminFailure()
    : super(
        name: 'Not An Admin',
        message: 'The user is not an admin.',
        categoryCode: FailureCategoryConstants.authentication,
        code: 'not_an_admin',
      );
}
