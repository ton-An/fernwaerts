import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class StorageReadFailure extends Failure {
  const StorageReadFailure()
    : super(
        name: 'Storage read failure',
        message: "Reading the app's storage failed",
        categoryCode: FailureCategoryConstants.storage,
        code: 'storage_read_failure',
      );
}
