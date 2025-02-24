part of 'location_history_modal.dart';

class _VerticalListItemDivider extends StatelessWidget {
  const _VerticalListItemDivider();

  @override
  Widget build(BuildContext context) {
    final LocationHistoryThemeData theme = LocationHistoryTheme.of(context);

    return Container(
      width: 3,
      height: 50,
      decoration: BoxDecoration(
          color: theme.colors.translucentBackgroundContrast,
          borderRadius: BorderRadius.circular(1)),
    );
  }
}
