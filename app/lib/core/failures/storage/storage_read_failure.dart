import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

/// {@template storage_read_failure}
/// A class that represents storage read failure.
/// {@endtemplate}
class StorageReadFailure extends Failure {
/// {@macro storage_read_failure}
  const StorageReadFailure()
    : super(
        name: 'Storage read failure',
        message: "Reading the app's storage failed",
        categoryCode: FailureCategoryConstants.storage,
        code: 'storage_read_failure',
      );
}
