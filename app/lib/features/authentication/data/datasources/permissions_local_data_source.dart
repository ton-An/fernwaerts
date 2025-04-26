import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:location_history/core/failures/permission/activity_permission_not_granted_failure.dart';
import 'package:location_history/core/failures/permission/background_location_permission_not_granted_failure.dart';
import 'package:location_history/core/failures/permission/basic_location_permission_not_granted_failure.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class PermissionsLocalDataSource {
  const PermissionsLocalDataSource();

  /// Requests the activity permission from the user.
  ///
  /// Throws:
  /// - [ActivityPermissionNotGrantedFailure]
  Future<void> requestActivityPermission();

  /// Requests the location permission from the user.
  ///
  /// Throws:
  /// - [BasicLocationPermissionNotGrantedFailure]
  /// - [BackgroundLocationPermissionNotGrantedFailure]
  Future<void> requestLocationPermission();
}

class PermissionsLocalDataSourceImpl extends PermissionsLocalDataSource {
  const PermissionsLocalDataSourceImpl({
    required this.flutterActivityRecognition,
  });

  final FlutterActivityRecognition flutterActivityRecognition;

  @override
  Future<void> requestActivityPermission() async {
    final ActivityPermission activityPermissionState =
        await flutterActivityRecognition.requestPermission();

    if (activityPermissionState != ActivityPermission.GRANTED) {
      throw const ActivityPermissionNotGrantedFailure();
    }
  }

  @override
  Future<void> requestLocationPermission() async {
    final PermissionStatus basicLocationPermissionStatus =
        await Permission.location.request();

    if (basicLocationPermissionStatus != PermissionStatus.granted) {
      throw const BasicLocationPermissionNotGrantedFailure();
    }

    final PermissionStatus backgroundLocationPermissionStatus =
        await Permission.locationAlways.request();

    if (backgroundLocationPermissionStatus != PermissionStatus.granted) {
      throw const BackgroundLocationPermissionNotGrantedFailure();
    }
  }
}
