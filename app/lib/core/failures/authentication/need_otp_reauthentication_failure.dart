import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class NeedOtpReauthenticationFailure extends Failure {
  const NeedOtpReauthenticationFailure()
    : super(
        name: 'Need OTP Reauthentication',
        message: 'An OTP has been sent to your email address.',
        categoryCode: FailureCategoryConstants.authentication,
        code: 'need_otp_reauthentication',
      );
}
