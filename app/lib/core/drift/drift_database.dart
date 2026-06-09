import 'package:drift/drift.dart';
import 'package:location_history/core/drift/activity_type_sql_converter.dart';
import 'package:location_history/core/drift/recording_trigger_sql_converter.dart';
import 'package:location_history/features/authentication/domain/enums/operating_system.dart';
import 'package:location_history/features/authentication/domain/models/device.dart';
import 'package:location_history/features/authentication/domain/models/user.dart';
import 'package:location_history/features/location_tracking/domain/enums/activity_type.dart';
import 'package:location_history/features/location_tracking/domain/enums/recording_trigger.dart';
import 'package:location_history/features/location_tracking/domain/models/location.dart';
import 'package:uuid/uuid.dart';

part 'activity_types_table.dart';
part 'activity_segments_table.dart';
part 'devices_table.dart';
part 'drift_database.g.dart';
part 'locations_table.dart';
part 'operating_systems_table.dart';
part 'public_info_table.dart';
part 'role_permissions_table.dart';
part 'user_roles_table.dart';
part 'users_table.dart';
part 'visits_table.dart';

/* 
  To-Do:
    - [ ] decide on best way to store the tables/data classes related to drift
    - [ ] decide on naming schemes. Especially for tables with enum ids
*/

/// {@template drift_app_database}
/// Drift database facade over the PowerSync-managed SQLite database.
///
/// Table definitions mirror the PowerSync client schema and the synced
/// Supabase tables used by the app.
/// {@endtemplate}
@DriftDatabase(
  tables: [
    ActivitySegments,
    Devices,
    Locations,
    PublicInfo,
    RolePermissions,
    UserRoles,
    Users,
    Visits,
  ],
)
class DriftAppDatabase extends _$DriftAppDatabase {
  /// {@macro drift_app_database}
  DriftAppDatabase(super.e);

  @override
  int get schemaVersion => 1;
}
