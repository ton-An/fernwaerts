import 'package:location_history/features/location_tracking/domain/enums/activity_type.dart';

/// {@template recognized_activity}
/// Activity classification observed near a recorded location update.
/// {@endtemplate}
class RecognizedActivity {
  /// {@macro recognized_activity}
  const RecognizedActivity({required this.type, required this.confidence});

  /// Fallback used before the platform reports an activity.
  static const RecognizedActivity unknown = RecognizedActivity(
    type: ActivityType.unknown,
    confidence: -1,
  );

  final ActivityType type;
  final double confidence;
}
