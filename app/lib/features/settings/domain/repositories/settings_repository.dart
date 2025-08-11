import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';

abstract class SettingsRepository {
  Future<Either<Failure, None>> updateEmail({required String newEmail});
}
