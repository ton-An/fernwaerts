part of 'drift_database.dart';

/* 
  To-Do:
    - [ ] Evaluate if we need to handle the os returned from the db being a String not included in the OperatingSystem enum. Atm this would lead to an exception.
*/

@UseRowClass(Device, constructor: 'fromDb', generateInsertable: true)
class Devices extends Table {
  @override
  String get tableName => 'devices';

  TextColumn get id => text().clientDefault(() => (const Uuid()).v4())();
  TextColumn get userId => text().named('user_id').references(Users, #id)();

  TextColumn get name => text()();
  TextColumn get model => text()();
  TextColumn get manufacturer => text()();
  TextColumn get operatingSystem =>
      textEnum<OperatingSystem>()
          .named('os_id')
          .references(OperatingSystems, #id)();
  TextColumn get osVersion => text().named('os_version')();
  TextColumn get appVersion => text().named('app_version')();

  DateTimeColumn get createdAt =>
      dateTime().named('created_at').clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt =>
      dateTime().named('updated_at').clientDefault(() => DateTime.now())();
}
