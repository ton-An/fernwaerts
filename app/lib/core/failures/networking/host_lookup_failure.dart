import 'package:location_history/core/failures/networking/network_failure.dart';

class HostLookupFailure extends NetworkFailure {
  HostLookupFailure({required super.serverType})
    : super(
        name: 'Host Lookup Failure',
        message: 'The host lookup of the ${serverType.name} server failed.',
        code: 'host_lookup_failure',
      );
}
