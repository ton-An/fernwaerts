import 'package:flutter/material.dart';
import 'package:location_history/core/theme/location_history_theme.dart';

enum _ModalSize {
  small,
  medium,
  large,
}

class LocationHistoryModal extends StatefulWidget {
  const LocationHistoryModal({
    super.key,
    required this.scrollController,
    required this.draggableScrollableController,
  });

  final ScrollController scrollController;
  final DraggableScrollableController draggableScrollableController;

  static const double largeModalHeight = 1;
  static const double mediumModalHeight = .6;
  static const double smallModalHeight = .2;

  @override
  State<LocationHistoryModal> createState() => _LocationHistoryModalState();
}

class _LocationHistoryModalState extends State<LocationHistoryModal> {
  double _dragStart = 0;

  double _getModalHeight(bool hasDraggedUp) {
    if (hasDraggedUp) {
      return LocationHistoryModal.largeModalHeight;
    } else {
      return LocationHistoryModal.smallModalHeight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final LocationHistoryThemeData theme = LocationHistoryTheme.of(context);
    return ClipRRect(
      borderRadius:
          BorderRadius.vertical(top: Radius.circular(theme.radii.xLarge)),
      child: BackdropFilter(
        filter: theme.misc.blurFilter,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          color: theme.colors.translucentBackground,
          child: Column(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onVerticalDragEnd: (details) {
                  final double dragEnd = details.globalPosition.dy;
                  widget.draggableScrollableController.animateTo(
                    _getModalHeight(_dragStart > dragEnd),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                },
                onVerticalDragUpdate: (details) {
                  double currentExtent =
                      widget.draggableScrollableController.size;

                  double newExtent = (currentExtent -
                          details.primaryDelta! /
                              MediaQuery.of(context).size.height)
                      .clamp(LocationHistoryModal.smallModalHeight,
                          LocationHistoryModal.largeModalHeight);
                  widget.draggableScrollableController.jumpTo(newExtent);
                },
                onVerticalDragStart: (details) {
                  _dragStart = details.globalPosition.dy;
                },
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: theme.spacing.medium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: theme.spacing.medium),
                      Center(
                        child: Container(
                          height: 5,
                          width: 36,
                          decoration: BoxDecoration(
                            color: theme.colors.translucentBackgroundContrast,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      SizedBox(height: theme.spacing.medium),
                      Text(
                        "History",
                        style: theme.text.largeTitle
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: widget.scrollController,
                  itemCount: 10,
                  padding: EdgeInsets.only(bottom: theme.spacing.medium),
                  itemBuilder: (context, index) {
                    return Text("Location $index");
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
