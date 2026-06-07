import 'package:flutter/services.dart';
import 'package:location_history/features/location_tracking/domain/models/recorded_location.dart';
import 'package:tracelet/tracelet.dart';

/// {@template ios_location_tracking_local_data_source}
/// Data source contract for the iOS background location tracking plugin.
///
/// This layer owns direct interaction with [Tracelet] and exposes plugin
/// updates as domain [RecordedLocation] values.
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
}

/// {@template ios_location_tracking_local_data_source_impl}
/// [Tracelet] implementation of [IOSLocationTrackingLocalDataSource].
/// {@endtemplate}
class IOSLocationTrackingLocalDataSourceImpl
    extends IOSLocationTrackingLocalDataSource {
  /// {@macro ios_location_tracking_local_data_source_impl}
  const IOSLocationTrackingLocalDataSourceImpl();

  @override
  Future<void> initTracking() async {
    await Tracelet.ready(
      Config.lowPower().copyWith(
        app: const AppConfig(startOnBoot: true, stopOnTerminate: false),
        ios: const IosConfig(
          preventSuspend: true,
          showsBackgroundLocationIndicator: true,
        ),
        persistence: const PersistenceConfig(persistMode: PersistMode.none),
      ),
    );
    await Tracelet.start();
  }

  @override
  Future<void> stopTracking() async {
    Tracelet.removeListeners();
    await Tracelet.stop();
  }

  @override
  Stream<RecordedLocation> locationChangeStream() {
    return Tracelet.locationStream.map(
      (Location traceletLocation) => RecordedLocation.fromTraceletLocation(
        traceletLocation: traceletLocation,
      ),
    );
  }
}
