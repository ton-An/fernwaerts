part of 'location_history_modal.dart';

/// {@template modal_handle}
/// A class that represents modal handle.
/// {@endtemplate}
class _ModalHandle extends StatelessWidget {
/// {@macro modal_handle}
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
