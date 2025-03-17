import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class StatusCodeNotOkFailure extends Failure {
  const StatusCodeNotOkFailure({required int statusCode})
    : super(
        name: "Status Code Not OK",
        message: "The provided status code is $statusCode",
        categoryCode: FailureCategoryConstants.networking,
        code: "status_code_not_ok",
      );
}
