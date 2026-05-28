import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class InvalidInviteLinkFailure extends Failure {
  const InvalidInviteLinkFailure()
    : super(
        name: 'Invalid Invite Link',
        message: 'The invite link is invalid or expired.',
        categoryCode: FailureCategoryConstants.authentication,
        code: 'invalid_invite_link',
      );
}
