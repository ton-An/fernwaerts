import 'package:powersync/powersync.dart';

/// PowerSync client schema for the tables available in the local sync database.
///
/// Keep this aligned with Supabase migrations, PowerSync sync rules, and the
/// Drift table definitions in this folder.
Schema schema = const Schema(([
  Table('public_info', [Column.text('name'), Column.text('value')]),
  Table('role_permissions', [Column.text('role'), Column.text('permission')]),
  Table('users', [
    Column.text('username'),
    Column.text('email'),
    Column.text('created_at'),
    Column.text('updated_at'),
    Column.text('deleted_at'),
  ]),
  Table('user_roles', [
    Column.text('user_id'),
    Column.text('role'),
    Column.text('invited_at'),
    Column.text('accepted_at'),
    Column.text('created_at'),
    Column.text('updated_at'),
    Column.text('deleted_at'),
  ]),
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
    Column.text('recording_trigger'),
    Column.real('battery_level'),
    Column.integer('is_device_charging'),
  ]),
  Table('activity_segments', [
    Column.text('user_id'),
    Column.text('start_location_id'),
    Column.text('end_location_id'),
  ]),
  Table('visits', [
    Column.text('user_id'),
    Column.text('name'),
    Column.text('arrival_location_id'),
    Column.text('departure_location_id'),
  ]),
]));
