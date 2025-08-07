import 'package:location_history/core/failures/networking/network_failure.dart';

class BadCertificateFailure extends NetworkFailure {
  BadCertificateFailure({required super.serverType})
    : super(
        name: 'Certificate Error',
        message: "The ${serverType.name} server's SSL certificate is invalid.",
        code: 'bad_certificate',
      );
}
