// GENERATED CODE DO NOT EDIT
// This file should be version controlled
import 'package:brick_sqlite/db.dart';
part '20250509143413.migration.dart';

/// All intelligently-generated migrations from all `@Migratable` classes on disk
final migrations = <Migration>{
  const Migration20250509143413(),};

/// A consumable database structure including the latest generated migration.
final schema = Schema(
  0,
  generatorVersion: 1,
  tables: <SchemaTable>{
    SchemaTable(
      'Location',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn('id', Column.varchar),
        SchemaColumn('user_id', Column.varchar),
        SchemaColumn('device_id', Column.varchar),
        SchemaColumn('timestamp', Column.datetime),
        SchemaColumn('latitude', Column.num),
        SchemaColumn('longitude', Column.num),
        SchemaColumn('coordinates_accuracy', Column.num),
        SchemaColumn('speed', Column.num),
        SchemaColumn('speed_accuracy', Column.num),
        SchemaColumn('heading', Column.num),
        SchemaColumn('heading_accuracy', Column.num),
        SchemaColumn('ellipsoidal_altitude', Column.num),
        SchemaColumn('altitude_accuracy', Column.num),
        SchemaColumn('activity_type', Column.integer),
        SchemaColumn('activity_confidence', Column.num),
        SchemaColumn('battery_level', Column.num),
        SchemaColumn('is_device_charging', Column.boolean),
      },
      indices: <SchemaIndex>{},
    ),
    SchemaTable(
      'Device',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn('id', Column.varchar),
        SchemaColumn('user_id', Column.varchar),
        SchemaColumn('name', Column.varchar),
        SchemaColumn('model', Column.varchar),
        SchemaColumn('manufacturer', Column.varchar),
        SchemaColumn('os', Column.integer),
        SchemaColumn('os_version', Column.varchar),
        SchemaColumn('app_version', Column.varchar),
        SchemaColumn('created_at', Column.datetime),
        SchemaColumn('updated_at', Column.datetime),
      },
      indices: <SchemaIndex>{},
    ),
    SchemaTable(
      'User',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn('id', Column.varchar),
        SchemaColumn('username', Column.varchar),
        SchemaColumn('email', Column.varchar),
      },
      indices: <SchemaIndex>{},
    ),
  },
);
