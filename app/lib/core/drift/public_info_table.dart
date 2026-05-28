part of 'drift_database.dart';

@DataClassName('PublicInfoTableRow')
class PublicInfo extends Table {
  @override
  String get tableName => 'public_info';

  TextColumn get id => text()();

  TextColumn get name => text()();

  TextColumn get value => text()();
}
