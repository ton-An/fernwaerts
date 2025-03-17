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

  IconData getIcon(
    ActivityType type,
  ) {
    switch (type) {
      case ActivityType.running:
        return Icons.run_circle;
      case ActivityType.cycling:
        return Icons.pedal_bike;
      case ActivityType.walking:
        return Icons.directions_walk;
      case ActivityType.driving:
        return Icons.directions_car;
    }
  }
}
