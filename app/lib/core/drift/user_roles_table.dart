part of 'drift_database.dart';

@DataClassName('UserRoleTableRow')
class UserRoles extends Table {
  @override
  String get tableName => 'user_roles';

  TextColumn get id => text()();

  TextColumn get userId => text().named('user_id').references(Users, #id)();

  TextColumn get role => text()();

  DateTimeColumn get invitedAt => dateTime().named('invited_at')();

  DateTimeColumn get acceptedAt => dateTime().named('accepted_at').nullable()();

  DateTimeColumn get createdAt => dateTime().named('created_at')();

  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  DateTimeColumn get deletedAt => dateTime().named('deleted_at').nullable()();
}
