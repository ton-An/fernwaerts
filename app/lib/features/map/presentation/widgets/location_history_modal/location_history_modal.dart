import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:location_history/core/l10n/app_localizations.dart';
import 'package:location_history/core/misc/mock_location_history_items.dart';
import 'package:location_history/core/misc/number_formatter.dart';
import 'package:location_history/core/misc/time_date_formatter.dart';
import 'package:location_history/features/map/domain/models/activity.dart';
import 'package:location_history/features/map/domain/models/place.dart';
import 'package:location_history/features/settings/pages/settings_page/settings_page.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

part '_activity_icon.dart';
part '_activity_list_item.dart';
part '_dotted_history_line.dart';
part '_header.dart';
part '_location_list.dart';
part '_modal_handle.dart';
part '_place_icon.dart';
part '_place_list_item.dart';
part '_vertical_list_item_divider.dart';

/* To-Do:
    - [ ] Factor in velocity of drag to determine if a drag was significant
    - [ ] Fix onPointerUp sometimes not being called (might only be an issue in simulators)
      - This is (at least partly) due to the maplibre package. It introduces (as ios support is still in alpha) render issues, 
        which includes that the pointer events get interrupted on fade out of the attribution widget
*/

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
  static const double smallModalHeight = .3;

  @override
  State<LocationHistoryModal> createState() => _LocationHistoryModalState();
}

class _LocationHistoryModalState extends State<LocationHistoryModal> {
  double _dragStart = 0;
  double _dragPosition = 0;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(theme.radii.xLarge),
      ),
      child: BackdropFilter(
        filter: theme.misc.blurFilter,
        child: Container(
          color: theme.colors.translucentBackground,
          child: Column(
            children: [
              Listener(
                behavior: HitTestBehavior.translucent,
                onPointerDown: (event) => _verticalDragStart(event.position.dy),
                onPointerUp: (_) => _verticalDragEnd(),
                onPointerMove: (event) {
                  _verticalDragUpdate(event.delta.dy, event.position.dy);
                },
                onPointerCancel: (_) => _verticalDragEnd(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: theme.spacing.medium,
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MediumGap(),
                      _ModalHandle(),
                      MediumGap(),
                      _Header(),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: _LocationList(scrollController: widget.scrollController),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _verticalDragStart(double dragStartPosition) {
    _dragStart = dragStartPosition;
    _dragPosition = dragStartPosition;
  }

  void _verticalDragUpdate(double dragDelta, double dragPosition) {
    double currentExtent = widget.draggableScrollableController.size;

    double newExtent =
        (currentExtent - dragDelta / MediaQuery.of(context).size.height).clamp(
          LocationHistoryModal.smallModalHeight,
          LocationHistoryModal.largeModalHeight,
        );
    widget.draggableScrollableController.jumpTo(newExtent);
    _dragPosition = dragPosition;
  }

  void _verticalDragEnd() {
    final double dragDelta = _dragStart - _dragPosition;

    if (dragDelta != 0) {
      final VerticalDirection dragDirection =
          _dragStart > _dragPosition
              ? VerticalDirection.up
              : VerticalDirection.down;
      final bool isDragSignificant = dragDelta.abs() > 70;

      final VerticalDirection dragDirectionToAnimate =
          isDragSignificant ? dragDirection : dragDirection.flip();

      widget.draggableScrollableController.animateTo(
        _getModalHeight(dragDirectionToAnimate),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  double _getModalHeight(VerticalDirection dragDirection) {
    if (dragDirection == VerticalDirection.up) {
      return LocationHistoryModal.largeModalHeight;
    } else {
      return LocationHistoryModal.smallModalHeight;
    }
  }
}

enum VerticalDirection {
  up,
  down;

  VerticalDirection flip() {
    if (this == VerticalDirection.up) {
      return VerticalDirection.down;
    } else {
      return VerticalDirection.up;
    }
  }
}
