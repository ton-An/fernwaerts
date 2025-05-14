part of 'map_page.dart';

class _MapAttribution extends StatelessWidget {
  const _MapAttribution({required this.draggableScrollableController});

  final DraggableScrollableController draggableScrollableController;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return GestureDetector(
      onTap: () {
        launchUrlString('https://www.openstreetmap.org/copyright');
      },
      child: AnimatedOpacity(
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
              child: Text(
                AppLocalizations.of(context)!.openStreetMapAttribution,
                style: theme.text.subhead.copyWith(
                  height: 1,
                  color: theme.colors.text.withValues(alpha: .7),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
