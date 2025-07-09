import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class LikelyConfigurationIssueFailure extends Failure {
  const LikelyConfigurationIssueFailure()
    : super(
        name: 'Likely Configuration Issue',
        message:
            'The entered port might be wrong or there might be security (RLS) issues',
        categoryCode: FailureCategoryConstants.networking,
        code: 'likely_configuration_issue',
      );
}
