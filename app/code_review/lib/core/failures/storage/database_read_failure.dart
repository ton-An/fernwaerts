import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

class DatabaseReadFailure extends Failure {
  const DatabaseReadFailure()
    : super(
        name: 'Database Read Failure',
        message: 'Reading the database failed.',
        categoryCode: FailureCategoryConstants.storage,
        code: 'database_read_failure',
      );
}
