import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class HostLookupFailure extends Failure {
  const HostLookupFailure()
    : super(
        name: "Host Lookup Failure",
        message: "The host lookup failed.",
        categoryCode: FailureCategoryConstants.networking,
        code: "host_lookup_failure",
      );
}
