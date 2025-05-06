import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'devices'),
)
class Device extends OfflineFirstWithSupabaseModel {
  Device({
    String? id,
    required this.userId,
    required this.name,
    required this.type,
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
  final String type;
  final String model;
  final String manufacturer;
  final String os;
  final String osVersion;
  final String appVersion;
  final DateTime createdAt;
  final DateTime updatedAt;
}
