part of 'drift_database.dart';

@DataClassName('ActivitySegmentTableRow')
class ActivitySegments extends Table {
  @override
  String get tableName => 'activity_segments';

  TextColumn get id => text()();

  TextColumn get userId => text().named('user_id').references(Users, #id)();

  TextColumn get startLocationId =>
      text().named('start_location_id').nullable()();

  TextColumn get endLocationId => text().named('end_location_id').nullable()();
}
