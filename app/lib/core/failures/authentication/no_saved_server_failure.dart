import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

/// {@template no_saved_server_failure}
/// A class that represents no saved server failure.
/// {@endtemplate}
class NoSavedServerFailure extends Failure {
/// {@macro no_saved_server_failure}
  const NoSavedServerFailure()
    : super(
        name: 'No Saved Server',
        message:
            'The app tried to init the saved server connection, but no saved server was found.',
        categoryCode: FailureCategoryConstants.authentication,
        code: 'no_saved_server',
      );
}
