import 'package:location_history/core/failures/failure_constants.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

class ExpiredRefreshTokenFailure extends Failure {
  const ExpiredRefreshTokenFailure()
    : super(
        name: 'Expired Refresh Token',
        message: 'The refresh token has expired or was already used.',
        categoryCode: FailureCategoryConstants.authentication,
        code: 'expired_refresh_token',
      );
}
