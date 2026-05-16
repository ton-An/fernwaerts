part of 'map_page.dart';

/// {@template map_page_modal}
/// The draggable location history modal section of the [MapPage].
///
/// It owns the [DraggableScrollableController] so the history modal and legend
/// visibility stay synchronized with the current sheet extent.
/// {@endtemplate}
class _Modal extends StatefulWidget {
  /// {@macro map_page_modal}
  const _Modal();

  @override
  State<_Modal> createState() => _ModalState();
}

class _ModalState extends State<_Modal> {
  late DraggableScrollableController _draggableScrollableController;

  @override
  void initState() {
    super.initState();

    _draggableScrollableController = DraggableScrollableController();

    _draggableScrollableController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return Expanded(
      child: DraggableScrollableSheet(
        initialChildSize: LocationHistoryModal.mediumModalHeight,
        minChildSize: LocationHistoryModal.smallModalHeight,
        maxChildSize: LocationHistoryModal.largeModalHeight,
        snap: true,
        snapSizes: const [
          LocationHistoryModal.smallModalHeight,
          LocationHistoryModal.largeModalHeight,
        ],
        controller: _draggableScrollableController,
        snapAnimationDuration: theme.durations.medium,
        builder:
            (context, scrollController) => Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AnimatedOpacity(
                  opacity: _shouldDisplayLegend() ? 1 : 0,
                  duration: theme.durations.short,
                  curve: Curves.easeOut,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: theme.spacing.medium,
                    ),
                    child: const Row(
                      children: [
                        Expanded(child: _TimeGradientLegend()),
                        MediumGap(),
                        _AttributionLegend(),
                      ],
                    ),
                  ),
                ),
                const XSmallGap(),
                Expanded(
                  child: LocationHistoryModal(
                    scrollController: scrollController,
                    draggableScrollableController:
                        _draggableScrollableController,
                  ),
                ),
              ],
            ),
      ),
    );
  }

  /// Whether the map legends should remain visible above the current sheet.
  bool _shouldDisplayLegend() {
    if (!_draggableScrollableController.isAttached) {
      return true;
    }

    return _draggableScrollableController.size <=
        LocationHistoryModal.mediumModalHeight;
  }
}
