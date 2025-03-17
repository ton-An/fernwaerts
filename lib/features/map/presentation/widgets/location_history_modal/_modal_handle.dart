part of 'location_history_modal.dart';

class _ModalHandle extends StatelessWidget {
  const _ModalHandle();

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return Center(
      child: Container(
        height: 5,
        width: 36,
        decoration: BoxDecoration(
          color: theme.colors.translucentBackgroundContrast,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
