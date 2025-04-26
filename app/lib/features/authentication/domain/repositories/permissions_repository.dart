import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';

abstract class PermissionsRepository {
  /// Requests permission to use location services.
  ///
  /// Failures:
  /// - [LocationPermissionNotGrantedFailure]
  Future<Either<Failure, None>> requestLocationPermission();

  /// Requests permission to use activity recognition services.
  ///
  /// Failures:
  /// - [ActivityPermissionNotGrantedFailure]
  Future<Either<Failure, None>> requestActivityPermission();
}
