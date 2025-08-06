part of 'drift_database.dart';

@UseRowClass(User)
class Users extends Table {
  @override
  String get tableName => 'users';

  TextColumn get id => text()();

  TextColumn get username => text()();

  TextColumn get email => text()();
}
