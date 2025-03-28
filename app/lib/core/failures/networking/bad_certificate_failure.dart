import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class BadCertificateFailure extends Failure {
  const BadCertificateFailure()
    : super(
        name: 'Certificate Error',
        message: "The server's SSL certificate is invalid.",
        categoryCode: FailureCategoryConstants.networking,
        code: 'bad_certificate',
      );
}
