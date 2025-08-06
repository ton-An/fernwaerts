part of 'drift_database.dart';

@DataClassName('OperatingSystemTableRow')
class OperatingSystems extends Table {
  @override
  String get tableName => 'operating_systems';

  TextColumn get id => textEnum<OperatingSystem>()();
}
