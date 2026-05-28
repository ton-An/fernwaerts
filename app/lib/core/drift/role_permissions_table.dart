part of 'drift_database.dart';

@DataClassName('RolePermissionTableRow')
class RolePermissions extends Table {
  @override
  String get tableName => 'role_permissions';

  TextColumn get id => text()();

  TextColumn get role => text()();

  TextColumn get permission => text()();
}
