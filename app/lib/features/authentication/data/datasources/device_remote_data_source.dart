import 'package:location_history/core/data/datasources/supabase_handler.dart';
import 'package:location_history/core/drift/drift_database.dart';
import 'package:location_history/features/authentication/domain/models/device.dart';

/// {@template device_remote_data_source}
/// Remote device data source contract for synced device registration data.
///
/// This layer writes device records to the PowerSync-backed local database so
/// they can be synchronized with the selected server.
/// {@endtemplate}
abstract class DeviceRemoteDataSource {
  /// {@macro device_remote_data_source}
  const DeviceRemoteDataSource();

  /// Saves the device information to the synced database.
  ///
  /// Parameters:
  /// - device: [Device] device record to save
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
