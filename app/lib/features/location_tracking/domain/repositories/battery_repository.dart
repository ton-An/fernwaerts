import 'package:location_history/features/location_tracking/domain/models/battery_status.dart';

/// {@template battery_repository}
/// Repository contract for reading the current device battery state.
/// {@endtemplate}
abstract class BatteryRepository {
  /// {@macro battery_repository}
  const BatteryRepository();

  /// Gets the current battery status.
  ///
  /// Returns:
  /// - [BatteryStatus] with the current level and charging state
  Future<BatteryStatus> getBatteryStatus();
}
