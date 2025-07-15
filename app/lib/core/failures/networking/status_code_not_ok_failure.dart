import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

/// {@template status_code_not_ok_failure}
/// A class that represents status code not ok failure.
/// {@endtemplate}
class StatusCodeNotOkFailure extends Failure {
/// {@macro status_code_not_ok_failure}
  const StatusCodeNotOkFailure({required int statusCode})
    : super(
        name: 'Status Code Not OK',
        message: 'The provided status code is $statusCode',
        categoryCode: FailureCategoryConstants.networking,
        code: 'status_code_not_ok',
      );
}
