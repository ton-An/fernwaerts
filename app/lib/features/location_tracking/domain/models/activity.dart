import 'package:flutter_activity_recognition/models/activity_type.dart';

class Activity {
  Activity({required this.type, required this.confidence});

  final ActivityType type;
  final double confidence;
}
