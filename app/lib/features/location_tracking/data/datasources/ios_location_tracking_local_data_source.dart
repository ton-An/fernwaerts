import 'dart:async';

import 'package:flutter/services.dart';
import 'package:location_history/features/location_tracking/domain/models/recorded_location.dart';
import 'package:tracelet/tracelet.dart';

/*
  To-Do:
    - [ ] Add error handling
*/

/// {@template ios_location_tracking_local_data_source}
/// Data source contract for the iOS background location tracking plugin.
///
/// This layer owns direct interaction with [BackgroundLocation] and exposes
/// plugin updates as domain [RecordedLocation] values.
/// {@endtemplate}
abstract class IOSLocationTrackingLocalDataSource {
  /// {@macro ios_location_tracking_local_data_source}
  const IOSLocationTrackingLocalDataSource();

  /// Initializes the tracking service.
  ///
  /// Call this before [locationChangeStream] or [updateDistanceFilter].
  ///
  /// Throws:
  /// - [PlatformException] from the underlying tracking plugin
  Future<void> initTracking();

  /// Stops the tracking service.
  ///
  /// Throws:
  /// - [PlatformException] from the underlying tracking plugin
  Future<void> stopTracking();

  /// Streams location updates from the tracking service.
  ///
  /// [initTracking] must be called before subscribing.
  ///
  /// Emits:
  /// - [RecordedLocation] values reported by the device
  Stream<RecordedLocation> locationChangeStream();

  /// Updates the distance filter for the tracking service.
  ///
  /// [initTracking] must be called before updating this setting.
  ///
  /// Parameters:
  /// - distanceFilter: [double] distance in meters that should be traveled
  ///   before another location is reported
  ///
  /// Throws:
  /// - [PlatformException] from the underlying tracking plugin
  Future<void> updateDistanceFilter({required double distanceFilter});
}

/// {@template ios_location_tracking_local_data_source_impl}
/// [BackgroundLocation] implementation of
/// [IOSLocationTrackingLocalDataSource].
/// {@endtemplate}
class IOSLocationTrackingLocalDataSourceImpl
    extends IOSLocationTrackingLocalDataSource {
  /// {@macro ios_location_tracking_local_data_source_impl}
  const IOSLocationTrackingLocalDataSourceImpl();

  @override
  Future<void> initTracking() async {
    print(await Tracelet.requestLocationAuthorization());
    print((await Tracelet.getHealth()).motionPermission);
    await Tracelet.ready(
      const Config(
        ios: IosConfig(preventSuspend: true),
        app: AppConfig(startOnBoot: true, stopOnTerminate: false),
        geo: GeoConfig(periodicLocationInterval: 60),
        logger: LoggerConfig(debug: true, logLevel: LogLevel.verbose),
      ),
    );
    await Tracelet.startBackgroundTask();
  }

  @override
  Future<void> stopTracking() async {
    // await BackgroundLocation.stopLocationService();
  }

  @override
  Stream<RecordedLocation> locationChangeStream() {
    final StreamController<RecordedLocation> locationChangeStreamController =
        StreamController();

    Tracelet.locationStream.listen((Location traceletLocation) {
      final RecordedLocation location = RecordedLocation.fromTraceletLocation(
        traceletLocation: traceletLocation,
      );

      locationChangeStreamController.add(location);
    });

    return locationChangeStreamController.stream;
  }

  @override
  Future<void> updateDistanceFilter({required double distanceFilter}) async {
    // await BackgroundLocation.updateDistanceFilter(distanceFilter);
  }
}
