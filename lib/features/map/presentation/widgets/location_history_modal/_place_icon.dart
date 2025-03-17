part of 'location_history_modal.dart';

class _PlaceIcon extends StatelessWidget {
  const _PlaceIcon({required this.type});
  final PlaceType type;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);
    final _PlaceIconData placeIconData = getIcon(type, theme);

    return Container(
      padding: EdgeInsets.all(theme.spacing.medium),
      decoration: BoxDecoration(
        color: placeIconData.color,
        shape: BoxShape.circle,
      ),
      child: Icon(
        placeIconData.icon,
        color: theme.colors.backgroundContrast.withValues(alpha: 0.6),
      ),
    );
  }

  _PlaceIconData getIcon(
    PlaceType type,
    WebfabrikThemeData theme,
  ) {
    switch (type) {
      case PlaceType.groceryStore:
        return _PlaceIconData(
          icon: Icons.local_grocery_store,
          color: theme.colors.primaryTranslucent,
        );
      case PlaceType.restaurant:
        return _PlaceIconData(
          icon: Icons.restaurant,
          color: theme.colors.error.withValues(alpha: 0.2),
        );
      case PlaceType.park:
        return _PlaceIconData(
          icon: Icons.park,
          color: theme.colors.success.withValues(alpha: 0.2),
        );
      case PlaceType.museum:
        return _PlaceIconData(
          icon: Icons.museum,
          color: theme.colors.primaryTranslucent,
        );
      case PlaceType.other:
        return _PlaceIconData(
          icon: Icons.place,
          color: theme.colors.translucentBackgroundContrast,
        );
    }
  }
}

class _PlaceIconData {
  const _PlaceIconData({required this.icon, required this.color});

  final IconData icon;
  final Color color;
}
