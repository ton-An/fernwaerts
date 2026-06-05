import 'package:webfabrik_theme/webfabrik_theme.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class EmailAlreadyExistsFailure extends Failure {
  const EmailAlreadyExistsFailure()
    : super(
        name: 'Email Already Exists',
        message: 'The email address is already in use.',
        categoryCode: FailureCategoryConstants.authentication,
        code: 'email_already_exists',
      );
}
