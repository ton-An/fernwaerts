import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class StorageWriteFailure extends Failure {
  const StorageWriteFailure()
    : super(
        name: 'Storage write failure',
        message: "Writing the app's storage failed",
        categoryCode: FailureCategoryConstants.storage,
        code: 'storage_write_failure',
      );
}
