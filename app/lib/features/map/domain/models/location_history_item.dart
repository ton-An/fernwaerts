abstract class LocationHistoryItem {
  LocationHistoryItem({
    required this.id,
    required this.startTime,
    required this.endTime,
  });

  final String id;
  final DateTime startTime;
  final DateTime endTime;
}
