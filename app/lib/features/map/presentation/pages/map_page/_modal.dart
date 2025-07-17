part of 'map_page.dart';

/// {@template modal}
/// A modal widget that displays  content.
/// {@endtemplate}
class _Modal extends StatefulWidget {
/// {@macro modal}
  const _Modal();

  @override
  State<_Modal> createState() => _ModalState();
}

/// {@template modal_state}
/// {@endtemplate}
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

  bool _shouldDisplayLegend() {
    if (!_draggableScrollableController.isAttached) {
      return true;
    }

    return _draggableScrollableController.size <=
        LocationHistoryModal.mediumModalHeight;
  }
}
