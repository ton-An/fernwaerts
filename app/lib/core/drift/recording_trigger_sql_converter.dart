import 'package:drift/drift.dart';
import 'package:location_history/features/location_tracking/domain/enums/recording_trigger.dart';

/// Converts recording trigger values between storage strings and the app's
/// Dart enum.
class RecordingTriggerSqlConverter
    extends TypeConverter<RecordingTrigger, String> {
  /// Creates a recording trigger converter.
  const RecordingTriggerSqlConverter();

  @override
  RecordingTrigger fromSql(String fromDb) =>
      RecordingTrigger.fromString(fromDb);

  @override
  String toSql(RecordingTrigger value) => value.toString();
}
