import 'package:drift/drift.dart';
import 'package:location_history/features/location_tracking/domain/enums/activity_type.dart';

/// Converts activity values between Supabase/PowerSync storage strings and
/// the app's Dart enum.
class ActivityTypeSqlConverter extends TypeConverter<ActivityType, String> {
  /// Creates an activity type converter.
  const ActivityTypeSqlConverter();

  @override
  ActivityType fromSql(String fromDb) => ActivityType.fromString(fromDb);

  @override
  String toSql(ActivityType value) => value.toString();
}
