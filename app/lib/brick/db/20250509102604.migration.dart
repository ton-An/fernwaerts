// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250509102604_up = [
  InsertTable('Location'),
  InsertTable('Device'),
  InsertTable('User'),
  InsertColumn('id', Column.varchar, onTable: 'Location'),
  InsertColumn('user_id', Column.varchar, onTable: 'Location'),
  InsertColumn('device_id', Column.varchar, onTable: 'Location'),
  InsertColumn('timestamp', Column.datetime, onTable: 'Location'),
  InsertColumn('latitude', Column.num, onTable: 'Location'),
  InsertColumn('longitude', Column.num, onTable: 'Location'),
  InsertColumn('coordinates_accuracy', Column.num, onTable: 'Location'),
  InsertColumn('speed', Column.num, onTable: 'Location'),
  InsertColumn('speed_accuracy', Column.num, onTable: 'Location'),
  InsertColumn('heading', Column.num, onTable: 'Location'),
  InsertColumn('heading_accuracy', Column.num, onTable: 'Location'),
  InsertColumn('ellipsoidal_altitude', Column.num, onTable: 'Location'),
  InsertColumn('altitude_accuracy', Column.num, onTable: 'Location'),
  InsertColumn('activity_type', Column.integer, onTable: 'Location'),
  InsertColumn('activity_confidence', Column.num, onTable: 'Location'),
  InsertColumn('battery_level', Column.num, onTable: 'Location'),
  InsertColumn('is_device_charging', Column.boolean, onTable: 'Location'),
  InsertColumn('id', Column.varchar, onTable: 'Device'),
  InsertColumn('user_id', Column.varchar, onTable: 'Device'),
  InsertColumn('name', Column.varchar, onTable: 'Device'),
  InsertColumn('model', Column.varchar, onTable: 'Device'),
  InsertColumn('manufacturer', Column.varchar, onTable: 'Device'),
  InsertColumn('os', Column.integer, onTable: 'Device'),
  InsertColumn('os_version', Column.varchar, onTable: 'Device'),
  InsertColumn('app_version', Column.varchar, onTable: 'Device'),
  InsertColumn('created_at', Column.datetime, onTable: 'Device'),
  InsertColumn('updated_at', Column.datetime, onTable: 'Device'),
  InsertColumn('id', Column.varchar, onTable: 'User'),
  InsertColumn('username', Column.varchar, onTable: 'User'),
  InsertColumn('email', Column.varchar, onTable: 'User')
];

const List<MigrationCommand> _migration_20250509102604_down = [
  DropTable('Location'),
  DropTable('Device'),
  DropTable('User'),
  DropColumn('id', onTable: 'Location'),
  DropColumn('user_id', onTable: 'Location'),
  DropColumn('device_id', onTable: 'Location'),
  DropColumn('timestamp', onTable: 'Location'),
  DropColumn('latitude', onTable: 'Location'),
  DropColumn('longitude', onTable: 'Location'),
  DropColumn('coordinates_accuracy', onTable: 'Location'),
  DropColumn('speed', onTable: 'Location'),
  DropColumn('speed_accuracy', onTable: 'Location'),
  DropColumn('heading', onTable: 'Location'),
  DropColumn('heading_accuracy', onTable: 'Location'),
  DropColumn('ellipsoidal_altitude', onTable: 'Location'),
  DropColumn('altitude_accuracy', onTable: 'Location'),
  DropColumn('activity_type', onTable: 'Location'),
  DropColumn('activity_confidence', onTable: 'Location'),
  DropColumn('battery_level', onTable: 'Location'),
  DropColumn('is_device_charging', onTable: 'Location'),
  DropColumn('id', onTable: 'Device'),
  DropColumn('user_id', onTable: 'Device'),
  DropColumn('name', onTable: 'Device'),
  DropColumn('model', onTable: 'Device'),
  DropColumn('manufacturer', onTable: 'Device'),
  DropColumn('os', onTable: 'Device'),
  DropColumn('os_version', onTable: 'Device'),
  DropColumn('app_version', onTable: 'Device'),
  DropColumn('created_at', onTable: 'Device'),
  DropColumn('updated_at', onTable: 'Device'),
  DropColumn('id', onTable: 'User'),
  DropColumn('username', onTable: 'User'),
  DropColumn('email', onTable: 'User')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250509102604',
  up: _migration_20250509102604_up,
  down: _migration_20250509102604_down,
)
class Migration20250509102604 extends Migration {
  const Migration20250509102604()
    : super(
        version: 20250509102604,
        up: _migration_20250509102604_up,
        down: _migration_20250509102604_down,
      );
}
