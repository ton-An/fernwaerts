import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/permission/activity_permission_not_granted_failure.dart';
import 'package:location_history/core/failures/permission/background_location_permission_not_granted_failure.dart';
import 'package:location_history/core/failures/permission/basic_location_permission_not_granted_failure.dart';

abstract class PermissionsRepository {
  const PermissionsRepository();

  /// Requests permission to use location services.
  ///
  /// Failures:
  /// - [BasicLocationPermissionNotGrantedFailure]
  /// - [BackgroundLocationPermissionNotGrantedFailure]
  Future<Either<Failure, None>> requestLocationPermission();

  /// Requests permission to use activity recognition services.
  ///
  /// Failures:
  /// - [ActivityPermissionNotGrantedFailure]
  Future<Either<Failure, None>> requestActivityPermission();
}
