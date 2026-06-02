import 'package:flutter_activity_recognition/flutter_activity_recognition.dart'
    as activityRecog;
import 'package:location_history/features/location_tracking/domain/enums/activity_type.dart';
import 'package:location_history/features/location_tracking/domain/models/recognized_activity.dart';

/// {@template activity_recognition_local_data_source}
/// Local data source for platform activity-recognition updates.
/// {@endtemplate}
abstract class ActivityRecognitionLocalDataSource {
  /// {@macro activity_recognition_local_data_source}
  const ActivityRecognitionLocalDataSource();

  /// Streams activity classifications reported by the platform.
  ///
  /// Emits:
  /// - [RecognizedActivity] values mapped from the activity-recognition plugin
  Stream<RecognizedActivity> activityChangeStream();
}

/// {@template activity_recognition_local_data_source_impl}
/// [activityRecog.FlutterActivityRecognition] implementation of
/// [ActivityRecognitionLocalDataSource].
/// {@endtemplate}
class ActivityRecognitionLocalDataSourceImpl
    implements ActivityRecognitionLocalDataSource {
  /// {@macro activity_recognition_local_data_source_impl}
  const ActivityRecognitionLocalDataSourceImpl({
    required this.flutterActivityRecognition,
  });

  final activityRecog.FlutterActivityRecognition flutterActivityRecognition;

  @override
  Stream<RecognizedActivity> activityChangeStream() {
    return flutterActivityRecognition.activityStream.map(
      (activityRecog.Activity activity) => RecognizedActivity(
        type: _activityTypeFromPlugin(activity.type),
        confidence: _confidenceFromPlugin(activity.confidence),
      ),
    );
  }

  ActivityType _activityTypeFromPlugin(
    activityRecog.ActivityType activityType,
  ) {
    switch (activityType) {
      case activityRecog.ActivityType.IN_VEHICLE:
        return ActivityType.inVehicle;
      case activityRecog.ActivityType.ON_BICYCLE:
        return ActivityType.onBicycle;
      case activityRecog.ActivityType.RUNNING:
        return ActivityType.running;
      case activityRecog.ActivityType.STILL:
        return ActivityType.still;
      case activityRecog.ActivityType.WALKING:
        return ActivityType.walking;
      case activityRecog.ActivityType.UNKNOWN:
        return ActivityType.unknown;
    }
  }

  double _confidenceFromPlugin(activityRecog.ActivityConfidence confidence) {
    switch (confidence) {
      case activityRecog.ActivityConfidence.HIGH:
        return 0.9;
      case activityRecog.ActivityConfidence.MEDIUM:
        return 0.65;
      case activityRecog.ActivityConfidence.LOW:
        return 0.25;
    }
  }
}
