import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class OtpInvalidFailure extends Failure {
  const OtpInvalidFailure()
    : super(
        name: 'OTP Invalid',
        message: 'The OTP you entered is either invalid or expired.',
        categoryCode: FailureCategoryConstants.authentication,
        code: 'otp_invalid',
      );
}
