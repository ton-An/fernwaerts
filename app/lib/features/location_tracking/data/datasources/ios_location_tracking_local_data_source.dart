import 'dart:async';

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:location_history/features/location_tracking/domain/models/recorded_location.dart';

/*
  To-Do:
    - [ ] Add error handling
*/

abstract class IOSLocationTrackingLocalDataSource {
  /// Initializes the tracking service
  Future<void> initTracking();

  /// Stops the tracking service
  Future<void> stopTracking();

  /// Streams location updates
  ///
  /// Emits:
  /// - [RecordedLocation] the current location of the user
  Stream<RecordedLocation> locationChangeStream();
}

/// {@template ios_location_tracking_local_data_source_impl}
/// Implementation of [IOSLocationTrackingLocalDataSource] for iOS platforms.
///
/// This class provides location tracking functionality specifically for iOS
/// devices using the background geolocation plugin.
/// {@endtemplate}
class IOSLocationTrackingLocalDataSourceImpl
    extends IOSLocationTrackingLocalDataSource {
  /// {@macro ios_location_tracking_local_data_source_impl}
  IOSLocationTrackingLocalDataSourceImpl();

  @override
  Future<void> initTracking() async {
    await bg.BackgroundGeolocation.ready(
      bg.Config(
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        stationaryRadius: 200,
        elasticityMultiplier: 18,
        stopOnStationary: true,
        stopOnTerminate: false,
        startOnBoot: true,
        showsBackgroundLocationIndicator: true,
      ),
    );
    bg.BackgroundGeolocation.start();
  }

  @override
  Future<void> stopTracking() async {
    await bg.BackgroundGeolocation.stop();
  }

  @override
  Stream<RecordedLocation> locationChangeStream() {
    final StreamController<RecordedLocation> locationChangeStreamController =
        StreamController();

    bg.BackgroundGeolocation.onLocation((bg.Location bgLocation) {
      if (bgLocation.sample) {
        return;
      }

      final RecordedLocation location = RecordedLocation.fromBGLocation(
        bgLocation,
      );

      locationChangeStreamController.add(location);
    });

    return locationChangeStreamController.stream;
  }
}
