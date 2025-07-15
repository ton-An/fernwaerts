part of 'location_history_modal.dart';

/// {@template vertical_list_item_divider}
/// A class that represents vertical list item divider.
/// {@endtemplate}
class _VerticalListItemDivider extends StatelessWidget {
/// {@macro vertical_list_item_divider}
  const _VerticalListItemDivider();

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return Container(
      width: 3,
      height: 50,
      decoration: BoxDecoration(
        color: theme.colors.translucentBackgroundContrast,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}
