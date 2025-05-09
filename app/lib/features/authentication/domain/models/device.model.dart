import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:location_history/features/authentication/domain/enums/operating_system.dart';
import 'package:uuid/uuid.dart';

/* 
  To-Do:
    - [ ] Evaluate if we need to handle the os returned from the db being a String not included in the OperatingSystem enum. Atm this would lead to an exception.
*/

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'devices'),
)
class Device extends OfflineFirstWithSupabaseModel {
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

  @Supabase(unique: true)
  final String id;

  final String userId;

  final String name;
  final String model;
  final String manufacturer;

  @Supabase(enumAsString: true)
  final OperatingSystem os;
  final String osVersion;
  final String appVersion;
  final DateTime createdAt;
  final DateTime updatedAt;
}
