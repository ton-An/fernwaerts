import 'dart:async';

import 'package:background_location_2/background_location.dart';
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

class IOSLocationTrackingLocalDataSourceImpl
    extends IOSLocationTrackingLocalDataSource {
  @override
  Future<void> initTracking() async {
    print("1");
    await BackgroundLocation.stopLocationService();
    print("2");
    await BackgroundLocation.startLocationService(
      distanceFilter: 10,
      fastestInterval: 0,
      interval: 0,
      startOnBoot: true,
      backgroundCallback: (_) => "",
      priority: LocationPriority.priorityHighAccuracy,
    );
    print("3");
  }

  @override
  Future<void> stopTracking() async {
    await BackgroundLocation.stopLocationService();
  }

  @override
  Stream<RecordedLocation> locationChangeStream() {
    final StreamController<RecordedLocation> locationChangeStreamController =
        StreamController();

    BackgroundLocation.getLocationUpdates((Location bgLocation) {
      final RecordedLocation location = RecordedLocation.fromBGLocation(
        bgLocation: bgLocation,
      );
      locationChangeStreamController.add(location);
    });

    return locationChangeStreamController.stream;
  }
}
