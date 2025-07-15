import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

/// {@template host_lookup_failure}
/// A class that represents host lookup failure.
/// {@endtemplate}
class HostLookupFailure extends Failure {
/// {@macro host_lookup_failure}
  const HostLookupFailure()
    : super(
        name: 'Host Lookup Failure',
        message: 'The host lookup failed.',
        categoryCode: FailureCategoryConstants.networking,
        code: 'host_lookup_failure',
      );
}
