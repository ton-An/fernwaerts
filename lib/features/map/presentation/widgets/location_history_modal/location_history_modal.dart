import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location_history/core/theme/location_history_theme.dart';
import 'package:location_history/core/widgets/gaps/gaps.dart';

part '_header.dart';
part '_location_list.dart';
part '_modal_handle.dart';

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
        child: Container(
          color: theme.colors.translucentBackground,
          child: Column(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onVerticalDragEnd: _verticalDragEnd,
                onVerticalDragUpdate: _verticalDragUpdate,
                onVerticalDragStart: _verticalDragStart,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: theme.spacing.medium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MediumGap(),
                      _ModalHandle(),
                      MediumGap(),
                      _Header(),
                      MediumGap(),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: _LocationList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _verticalDragStart(DragStartDetails details) {
    _dragStart = details.globalPosition.dy;
  }

  void _verticalDragUpdate(DragUpdateDetails details) {
    (details) {
      double currentExtent = widget.draggableScrollableController.size;

      double newExtent = (currentExtent -
              details.primaryDelta! / MediaQuery.of(context).size.height)
          .clamp(LocationHistoryModal.smallModalHeight,
              LocationHistoryModal.largeModalHeight);
      widget.draggableScrollableController.jumpTo(newExtent);
    };
  }

  void _verticalDragEnd(DragEndDetails details) {
    final double dragEnd = details.globalPosition.dy;
    widget.draggableScrollableController.animateTo(
      _getModalHeight(_dragStart > dragEnd),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
