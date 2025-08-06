part of 'drift_database.dart';

@UseRowClass(Location, constructor: 'fromDb', generateInsertable: true)
class Locations extends Table {
  @override
  String get tableName => 'raw_location_data';

  TextColumn get id => text().clientDefault(() => (const Uuid()).v4())();
  TextColumn get userId => text().named('user_id').references(Users, #id)();
  TextColumn get deviceId =>
      text().named('device_id').references(Devices, #id)();

  DateTimeColumn get timestamp => dateTime().named('timestamp')();

  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get coordinatesAccuracy => real().named('coordinates_accuracy')();
  RealColumn get speed => real()();
  RealColumn get speedAccuracy => real().named('speed_accuracy')();
  RealColumn get heading => real()();
  RealColumn get headingAccuracy => real().named('heading_accuracy')();
  RealColumn get ellipsoidalAltitude => real().named('ellipsoidal_altitude')();
  RealColumn get altitudeAccuracy => real().named('altitude_accuracy')();

  TextColumn get activityType =>
      textEnum<ActivityType>()
          .named('activity_type_id')
          .references(ActivityTypes, #id)();
  RealColumn get activityConfidence => real().named('activity_confidence')();
  RealColumn get batteryLevel => real().named('battery_level')();
  BoolColumn get isDeviceCharging => boolean().named('is_device_charging')();
}
