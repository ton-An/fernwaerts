import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

/// {@template storage_write_failure}
/// A class that represents storage write failure.
/// {@endtemplate}
class StorageWriteFailure extends Failure {
/// {@macro storage_write_failure}
  const StorageWriteFailure()
    : super(
        name: 'Storage write failure',
        message: "Writing the app's storage failed",
        categoryCode: FailureCategoryConstants.storage,
        code: 'storage_write_failure',
      );
}
