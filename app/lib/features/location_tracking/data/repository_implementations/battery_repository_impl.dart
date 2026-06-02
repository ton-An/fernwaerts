import 'package:location_history/features/location_tracking/data/datasources/battery_local_data_source.dart';
import 'package:location_history/features/location_tracking/domain/models/battery_status.dart';
import 'package:location_history/features/location_tracking/domain/repositories/battery_repository.dart';

/// {@template battery_repository_impl}
/// Data-layer implementation of [BatteryRepository].
/// {@endtemplate}
class BatteryRepositoryImpl extends BatteryRepository {
  /// {@macro battery_repository_impl}
  const BatteryRepositoryImpl({required this.batteryLocalDataSource});

  final BatteryLocalDataSource batteryLocalDataSource;

  @override
  Future<BatteryStatus> getBatteryStatus() async {
    return await batteryLocalDataSource.getBatteryStatus();
  }
}
