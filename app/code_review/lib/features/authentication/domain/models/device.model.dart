// ignore_for_file: must_be_immutable

import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:equatable/equatable.dart';
import 'package:location_history/features/authentication/domain/enums/operating_system.dart';
import 'package:location_history/features/authentication/domain/models/raw_device.dart';
import 'package:uuid/uuid.dart';

/* 
  To-Do:
    - [ ] Evaluate if we need to handle the os returned from the db being a String not included in the OperatingSystem enum. Atm this would lead to an exception.
*/

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'devices'),
)
class Device extends OfflineFirstWithSupabaseModel with EquatableMixin {
  Device({
    String? id,
    required this.userId,
    required this.name,
    required this.model,
    required this.manufacturer,
    required this.os,
    required this.osVersion,
    required this.appVersion,
    required this.createdAt,
    required this.updatedAt,
  }) : id = id ?? (const Uuid()).v4();

  @Sqlite(unique: true)
  @Supabase(unique: true)
  final String id;

  final String userId;

  final String name;
  final String model;
  final String manufacturer;

  @Supabase(name: 'os_id', enumAsString: true)
  final OperatingSystem os;
  final String osVersion;
  final String appVersion;
  final DateTime createdAt;
  final DateTime updatedAt;

  static Device fromRawDevice({
    required RawDevice rawDevice,
    required String appVersion,
    required String userId,
  }) {
    final DateTime now = DateTime.now();

    return Device(
      userId: userId,
      name: rawDevice.name,
      model: rawDevice.model,
      manufacturer: rawDevice.manufacturer,
      os: rawDevice.os,
      osVersion: rawDevice.osVersion,
      appVersion: appVersion,
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    name,
    model,
    manufacturer,
    os,
    osVersion,
    appVersion,
    createdAt,
    updatedAt,
  ];
}
