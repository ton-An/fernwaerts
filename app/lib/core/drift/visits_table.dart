part of 'drift_database.dart';

@DataClassName('VisitTableRow')
class Visits extends Table {
  @override
  String get tableName => 'visits';

  TextColumn get id => text()();

  TextColumn get userId => text().named('user_id').references(Users, #id)();

  TextColumn get name => text()();

  TextColumn get arrivalLocationId =>
      text().named('arrival_location_id').nullable()();

  TextColumn get departureLocationId =>
      text().named('departure_location_id').nullable()();
}
