import 'package:equatable/equatable.dart';

/// {@template battery_status}
/// Battery state recorded alongside a location point.
/// {@endtemplate}
class BatteryStatus extends Equatable {
  /// {@macro battery_status}
  const BatteryStatus({required this.level, required this.isDeviceCharging});

  /// Battery status used when the platform cannot provide a reading.
  static const BatteryStatus unknown = BatteryStatus(
    level: -1,
    isDeviceCharging: false,
  );

  /// Battery level as a percentage.
  final double level;

  /// Whether the device is connected to power or charging.
  final bool isDeviceCharging;

  @override
  List<Object?> get props => [level, isDeviceCharging];
}
