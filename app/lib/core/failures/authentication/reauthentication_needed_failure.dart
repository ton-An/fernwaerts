import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class ReauthenticationNeededFailure extends Failure {
  const ReauthenticationNeededFailure()
    : super(
        name: 'Reauthentication Needed',
        message:
            'You need to reauthenticate before performing this action. Please try again.',
        categoryCode: FailureCategoryConstants.authentication,
        code: 'reauthentication_needed',
      );
}
