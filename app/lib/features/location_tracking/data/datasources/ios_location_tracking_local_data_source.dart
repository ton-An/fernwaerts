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

  /// Updates the distance filter for the tracking service
  ///
  /// Parameters:
  /// - [distanceFilter] the distance in meters that must be traveled before a new location is recorded
  Future<void> updateDistanceFilter({required double distanceFilter});
}

class IOSLocationTrackingLocalDataSourceImpl
    extends IOSLocationTrackingLocalDataSource {
  @override
  Future<void> initTracking() async {
    await BackgroundLocation.stopLocationService();
    await BackgroundLocation.startLocationService(
      distanceFilter: 100,
      fastestInterval: 0,
      interval: 0,
      startOnBoot: true,
      backgroundCallback: (_) => "",
      priority: LocationPriority.priorityHighAccuracy,
    );
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

  @override
  Future<void> updateDistanceFilter({required double distanceFilter}) async {
    await BackgroundLocation.updateDistanceFilter(distanceFilter);
  }
}
