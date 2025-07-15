import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

/// {@template bad_certificate_failure}
/// A class that represents bad certificate failure.
/// {@endtemplate}
class BadCertificateFailure extends Failure {
/// {@macro bad_certificate_failure}
  const BadCertificateFailure()
    : super(
        name: 'Certificate Error',
        message: "The server's SSL certificate is invalid.",
        categoryCode: FailureCategoryConstants.networking,
        code: 'bad_certificate',
      );
}
