part of 'location_history_modal.dart';

class _ActivityIcon extends StatelessWidget {
  const _ActivityIcon({required this.type});

  final ActivityType type;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);
    final IconData? icon = getIcon(type);

    if (icon == null) {
      return const SizedBox.shrink();
    }

    return Icon(
      icon,
      color: theme.colors.backgroundContrast.withValues(alpha: 0.6),
    );
  }

  IconData? getIcon(ActivityType type) {
    switch (type) {
      case ActivityType.walking:
        return Icons.directions_walk_rounded;
      case ActivityType.onFoot:
        return Icons.directions_walk_rounded;
      case ActivityType.running:
        return Icons.directions_run_rounded;
      case ActivityType.onBicycle:
        return Icons.pedal_bike_rounded;
      case ActivityType.inVehicle:
        return Icons.directions_car_filled_rounded;
      case ActivityType.still:
      case ActivityType.unknown:
        return null;
    }
  }
}
