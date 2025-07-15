import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/failure_constants.dart';

/// {@template database_read_failure}
/// A class that represents database read failure.
/// {@endtemplate}
class DatabaseReadFailure extends Failure {
/// {@macro database_read_failure}
  const DatabaseReadFailure()
    : super(
        name: 'Database Read Failure',
        message: 'Reading the database failed.',
        categoryCode: FailureCategoryConstants.storage,
        code: 'database_read_failure',
      );
}
