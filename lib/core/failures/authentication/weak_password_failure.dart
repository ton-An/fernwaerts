import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class WeakPasswordFailure extends Failure {
  const WeakPasswordFailure()
      : super(
          name: "Weak Password",
          message: "The password is too weak.",
          categoryCode: FailureCategoryConstants.authentication,
          code: "weak_password",
        );
}
