import 'package:location_history/features/location_tracking/domain/models/activity.dart';

class Location {
  const Location({
    required this.lat,
    required this.long,
    required this.activity,
  });

  final double lat;
  final double long;
  final Activity activity;
}
