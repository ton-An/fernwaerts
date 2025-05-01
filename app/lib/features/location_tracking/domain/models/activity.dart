import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:location_history/features/location_tracking/domain/enums/activity_type.dart';

class Activity {
  Activity({required this.type, required this.confidence});

  final ActivityType type;
  final double confidence;

  static Activity fromBGActivity(bg.Activity bgActivity) {
    return Activity(
      type: ActivityType.fromBGActivityType(bgActivityType: bgActivity.type),
      confidence: bgActivity.confidence / 100,
    );
  }
}
