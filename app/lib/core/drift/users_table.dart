part of 'drift_database.dart';

@UseRowClass(User)
class Users extends Table {
  @override
  String get tableName => 'users';

  TextColumn get id => text()();

  TextColumn get username => text()();

  TextColumn get email => text()();

  DateTimeColumn get createdAt => dateTime().named('created_at')();

  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  DateTimeColumn get deletedAt => dateTime().named('deleted_at').nullable()();
}
