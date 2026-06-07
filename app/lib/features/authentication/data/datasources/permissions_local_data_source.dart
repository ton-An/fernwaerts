import 'package:location_history/core/failures/permission/activity_permission_not_granted_failure.dart';
import 'package:location_history/core/failures/permission/background_location_permission_not_granted_failure.dart';
import 'package:location_history/core/failures/permission/basic_location_permission_not_granted_failure.dart';
import 'package:tracelet/tracelet.dart';

/// {@template permissions_local_data_source}
/// Local permission data source contract for activity and location prompts.
///
/// This layer owns platform permission requests needed before location tracking
/// can start. Repository implementations convert permission failures into
/// domain results.
/// {@endtemplate}
abstract class PermissionsLocalDataSource {
  /// {@macro permissions_local_data_source}
  const PermissionsLocalDataSource();

  /// Requests activity recognition permission from the user.
  ///
  /// Throws:
  /// - [ActivityPermissionNotGrantedFailure]
  Future<void> requestActivityPermission();

  /// Requests foreground and background location permissions from the user.
  ///
  /// Throws:
  /// - [BasicLocationPermissionNotGrantedFailure]
  /// - [BackgroundLocationPermissionNotGrantedFailure]
  Future<void> requestLocationPermission();
}

class PermissionsLocalDataSourceImpl extends PermissionsLocalDataSource {
  const PermissionsLocalDataSourceImpl({
    required this.traceletAuthorizationWrapper,
  });

  final TraceletAuthorizationWrapper traceletAuthorizationWrapper;

  @override
  Future<void> requestActivityPermission() async {
    final MotionAuthorizationStatus motionAuthorizationStatus =
        await traceletAuthorizationWrapper.requestMotionAuthorization();

    if (motionAuthorizationStatus != MotionAuthorizationStatus.granted) {
      throw const ActivityPermissionNotGrantedFailure();
    }
  }

  @override
  Future<void> requestLocationPermission() async {
    final AuthorizationStatus locationAuthorizationStatus =
        await traceletAuthorizationWrapper.requestLocationAuthorization();

    if (locationAuthorizationStatus == AuthorizationStatus.denied ||
        locationAuthorizationStatus == AuthorizationStatus.deniedForever ||
        locationAuthorizationStatus == AuthorizationStatus.notDetermined) {
      throw const BasicLocationPermissionNotGrantedFailure();
    }

    if (locationAuthorizationStatus != AuthorizationStatus.always) {
      throw const BackgroundLocationPermissionNotGrantedFailure();
    }
  }
}

/// Wrapper around Tracelet static authorization APIs.
///
/// Keeping these calls behind an injectable wrapper lets the data source stay
/// testable while still using Tracelet's native permission flow.
class TraceletAuthorizationWrapper {
  const TraceletAuthorizationWrapper();

  Future<MotionAuthorizationStatus> requestMotionAuthorization() {
    return Tracelet.requestMotionAuthorization();
  }

  Future<AuthorizationStatus> requestLocationAuthorization() {
    return Tracelet.requestLocationAuthorization();
  }
}
