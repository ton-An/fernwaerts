import 'dart:async';

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:location_history/features/location_tracking/domain/models/location.dart';

/*
  To-Do:
    - [ ] Add error handling
*/

abstract class IOSLocationTrackingLocalDataSource {
  /// Initializes the tracking service
  ///
  /// Throws:
  /// - ...TBD
  Future<void> initTracking();

  /// Streams location updates
  ///
  /// Emits:
  /// - [Location] the current location of the user
  Stream<Location> locationChangeStream();
}

class IOSLocationTrackingLocalDataSourceImpl
    extends IOSLocationTrackingLocalDataSource {
  @override
  Future<void> initTracking() async {
    await bg.BackgroundGeolocation.ready(
      bg.Config(
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        stationaryRadius: 200,
        elasticityMultiplier: 1.75,
        // might want to change to 10. Look at docs to investigate
        desiredOdometerAccuracy: 100,
        stopOnStationary: true,
        stopOnTerminate: false,
        startOnBoot: true,
        debug: true,
        showsBackgroundLocationIndicator: true,
      ),
    );

    await bg.BackgroundGeolocation.start();
  }

  @override
  Stream<Location> locationChangeStream() {
    final StreamController<Location> locationChangeStreamController =
        StreamController();

    bg.BackgroundGeolocation.onLocation((bg.Location bgLocation) {
      if (bgLocation.sample) {
        return;
      }

      final Location location = Location.fromBGLocation(bgLocation);

      locationChangeStreamController.sink.add(location);
    });

    return locationChangeStreamController.stream;
  }
}
