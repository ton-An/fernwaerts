import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

/// {@template likely_configuration_issue_failure}
/// A class that represents likely configuration issue failure.
/// {@endtemplate}
class LikelyConfigurationIssueFailure extends Failure {
/// {@macro likely_configuration_issue_failure}
  const LikelyConfigurationIssueFailure()
    : super(
        name: 'Likely Configuration Issue',
        message:
            'The entered port might be wrong or there might be security (RLS) issues',
        categoryCode: FailureCategoryConstants.networking,
        code: 'likely_configuration_issue',
      );
}
