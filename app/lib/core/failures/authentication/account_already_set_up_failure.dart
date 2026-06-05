import 'package:webfabrik_theme/webfabrik_theme.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class AccountAlreadySetUpFailure extends Failure {
  const AccountAlreadySetUpFailure()
    : super(
        name: 'Account Already Set Up',
        message: 'This invited account has already been set up.',
        categoryCode: FailureCategoryConstants.authentication,
        code: 'account_already_set_up',
      );
}
