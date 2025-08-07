part of 'drift_database.dart';

@DataClassName('ActivityTypesTableRow')
class ActivityTypes extends Table {
  @override
  String get tableName => 'activity_types';

  TextColumn get id => textEnum<ActivityType>()();
}
