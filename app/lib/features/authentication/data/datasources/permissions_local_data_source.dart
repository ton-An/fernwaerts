import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:location_history/core/failures/permission/activity_permission_not_granted_failure.dart';
import 'package:location_history/core/failures/permission/background_location_permission_not_granted_failure.dart';
import 'package:location_history/core/failures/permission/basic_location_permission_not_granted_failure.dart';
import 'package:permission_handler/permission_handler.dart';

/*
  To-Do:
    - [ ] Might need to add location precision permission for ios
    - [ ] At the moment the permission_handler package has a bug where you can't await the response for the locationAlways Permission. 
          Due to that the BackgroundLocationPermissionNotGrantedFailure will be thrown before the user even has a chance to allow the permission.
*/

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
