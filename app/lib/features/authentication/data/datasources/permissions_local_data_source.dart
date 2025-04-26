import 'package:location_history/core/failures/permission/activity_permission_not_granted_failure.dart';
import 'package:location_history/core/failures/permission/location_permission_not_granted_failure.dart';

abstract class PermissionsLocalDataSource {
  /// Requests the activity permission from the user.
  ///
  /// Throws:
  /// - [ActivityPermissionNotGrantedFailure]
  Future<void> requestActivityPermission();

  /// Requests the location permission from the user.
  ///
  /// Throws:
  /// - [LocationPermissionNotGrantedFailure]
  Future<void> requestLocationPermission();
}

class PermissionsLocalDataSourceImpl extends PermissionsLocalDataSource {
  @override
  Future<void> requestActivityPermission() {
    // TODO: implement requestActivityPermission
    throw UnimplementedError();
  }

  @override
  Future<void> requestLocationPermission() {
    // TODO: implement requestLocationPermission
    throw UnimplementedError();
  }
}
