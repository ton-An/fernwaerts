import 'package:powersync/powersync.dart';

Schema schema = const Schema(([
  // devices
  // activity types
  // locations
  // operating systems
  // users
  Table('devices', [
    Column.text('user_id'),
    Column.text('name'),
    Column.text('model'),
    Column.text('manufacturer'),
    Column.text('os_id'),
    Column.text('os_version'),
    Column.text('app_version'),
    Column.text('created_at'),
    Column.text('updated_at'),
  ]),
  Table('activity_types', []),
  Table('raw_location_data', [
    Column.text('user_id'),
    Column.text('device_id'),
    Column.text('timestamp'),
    Column.real('latitude'),
    Column.real('longitude'),
    Column.real('coordinates_accuracy'),
    Column.real('speed'),
    Column.real('speed_accuracy'),
    Column.real('heading'),
    Column.real('heading_accuracy'),
    Column.real('ellipsoidal_altitude'),
    Column.real('altitude_accuracy'),
    Column.text('activity_type_id'),
    Column.real('activity_confidence'),
    Column.real('battery_level'),
    Column.integer('is_device_charging'),
  ]),
  Table('operating_systems', []),
  Table('users', [Column.text('username'), Column.text('email')]),
]));
