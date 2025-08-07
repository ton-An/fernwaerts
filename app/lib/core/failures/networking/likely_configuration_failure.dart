import 'package:location_history/core/failures/networking/network_failure.dart';

class LikelyConfigurationIssueFailure extends NetworkFailure {
  LikelyConfigurationIssueFailure({required super.serverType})
    : super(
        name: 'Likely Configuration Issue',
        message:
            'One likely reason could be that the port of the ${serverType.name} server is wrong',
        code: 'likely_configuration_issue',
      );
}
