part of 'location_history_modal.dart';

class _ActivityIcon extends StatelessWidget {
  const _ActivityIcon({required this.type});

  final ActivityType type;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);
    final IconData icon = getIcon(type);
    return Icon(
      icon,
      color: theme.colors.backgroundContrast.withValues(alpha: 0.6),
    );
  }

  IconData getIcon(ActivityType type) {
    switch (type) {
      case ActivityType.running:
        return Icons.directions_run;
      case ActivityType.onBicycle:
        return Icons.directions_bike_rounded;
      case ActivityType.inVehicle:
        return Icons.directions_car;
      case ActivityType.walking:
      case ActivityType.onFoot:
      case ActivityType.still:
      case ActivityType.unknown:
        return Icons.directions_walk;
    }
  }
}
