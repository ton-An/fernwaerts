import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class NoSavedServerFailure extends Failure {
  const NoSavedServerFailure()
    : super(
        name: 'No Saved Server',
        message:
            'The app tried to init the saved server connection, but no saved server was found.',
        categoryCode: FailureCategoryConstants.authentication,
        code: 'no_saved_server',
      );
}
