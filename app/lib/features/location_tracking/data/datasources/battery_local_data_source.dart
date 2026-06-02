import 'package:battery_plus/battery_plus.dart';
import 'package:location_history/features/location_tracking/domain/models/battery_status.dart';

/// {@template battery_local_data_source}
/// Data source contract for reading battery information from the platform.
/// {@endtemplate}
abstract class BatteryLocalDataSource {
  /// {@macro battery_local_data_source}
  const BatteryLocalDataSource();

  /// Gets the current battery status.
  ///
  /// Returns:
  /// - [BatteryStatus] with the current level and charging state
  Future<BatteryStatus> getBatteryStatus();
}

/// {@template battery_local_data_source_impl}
/// [Battery] implementation of [BatteryLocalDataSource].
/// {@endtemplate}
class BatteryLocalDataSourceImpl extends BatteryLocalDataSource {
  /// {@macro battery_local_data_source_impl}
  const BatteryLocalDataSourceImpl({required this.battery});

  final Battery battery;

  @override
  Future<BatteryStatus> getBatteryStatus() async {
    final int level = await battery.batteryLevel;
    final BatteryState state = await battery.batteryState;

    return BatteryStatus(
      level: level / 100,
      isDeviceCharging: _isDeviceCharging(state),
    );
  }

  bool _isDeviceCharging(BatteryState state) {
    return state == BatteryState.charging ||
        state == BatteryState.full ||
        state == BatteryState.connectedNotCharging;
  }
}
