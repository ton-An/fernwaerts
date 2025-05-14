part of 'map_page.dart';

class _MapTimeGradient extends StatelessWidget {
  const _MapTimeGradient({required this.draggableScrollableController});

  final DraggableScrollableController draggableScrollableController;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return AnimatedOpacity(
      duration: theme.durations.short,
      opacity:
          draggableScrollableController.isAttached
              ? draggableScrollableController.size <=
                      LocationHistoryModal.mediumModalHeight
                  ? 1
                  : 0
              : 1,
      curve: Curves.easeOut,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(theme.radii.small),
        child: BackdropFilter(
          filter: theme.misc.blurFilter,
          child: Container(
            padding: EdgeInsets.all(theme.spacing.xxSmall),
            color: theme.colors.translucentBackground,
            child: Container(
              height: 10,
              margin: EdgeInsets.all(theme.spacing.xTiny),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.3),
                gradient: const LinearGradient(
                  colors: [
                    Colors.purple,
                    Colors.blue,
                    Colors.teal,
                    Colors.green,
                    Colors.yellow,
                    Colors.orange,
                    Colors.red,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
