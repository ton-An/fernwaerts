import 'package:drift/drift.dart';
import 'package:location_history/features/authentication/domain/enums/operating_system.dart';
import 'package:location_history/features/authentication/domain/models/device.dart';
import 'package:location_history/features/authentication/domain/models/user.dart';
import 'package:location_history/features/location_tracking/domain/enums/activity_type.dart';
import 'package:location_history/features/location_tracking/domain/models/location.dart';
import 'package:uuid/uuid.dart';

part 'activity_types_table.dart';
part 'devices_table.dart';
part 'drift_database.g.dart';
part 'locations_table.dart';
part 'operating_systems_table.dart';
part 'users_table.dart';

/* 
  To-Do:
    - [ ] decide on best way to store the tables/data classes related to drift
    - [ ] decide on naming schemes. Especially for tables with enum ids
*/

@DriftDatabase(
  tables: [ActivityTypes, Devices, Locations, OperatingSystems, Users],
)
class DriftAppDatabase extends _$DriftAppDatabase {
  DriftAppDatabase(super.e);

  @override
  int get schemaVersion => 1;
}
