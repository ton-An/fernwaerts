import 'package:location_history/core/data/datasources/supabase_handler.dart';
import 'package:location_history/core/drift/drift_database.dart';
import 'package:location_history/features/authentication/domain/models/device.dart';

abstract class DeviceRemoteDataSource {
  /// Saves the device's information to the database
  ///
  /// Parameters:
  /// - [Device] device: The device object to save.
  Future<void> saveDeviceInfoToDB({required Device device});
}

class DeviceRemoteDataSourceImpl implements DeviceRemoteDataSource {
  const DeviceRemoteDataSourceImpl({required this.supabaseHandler});

  final SupabaseHandler supabaseHandler;

  @override
  Future<void> saveDeviceInfoToDB({required Device device}) async {
    final DriftAppDatabase driftDatabase = await supabaseHandler.driftDatabase;

    await driftDatabase
        .into(driftDatabase.devices)
        .insert(device.toInsertable());
  }
}
