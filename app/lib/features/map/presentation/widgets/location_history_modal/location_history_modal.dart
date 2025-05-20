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

/// {@template location_history_modal}
/// A draggable modal sheet that displays the user's location history.
///
/// This widget allows the user to view their location history in a list format.
/// It can be dragged to three different heights: small, medium (implicitly),
/// and large, controlled by a [DraggableScrollableController].
///
/// The modal includes a header, a draggable handle, and a scrollable list
/// of location and activity items.
/// {@endtemplate}
class LocationHistoryModal extends StatefulWidget {
  /// {@macro location_history_modal}
  const LocationHistoryModal({
    super.key,
    required this.scrollController,
    required this.draggableScrollableController,
  });

  /// The [ScrollController] for the list of location history items within the modal.
  final ScrollController scrollController;

  /// The [DraggableScrollableController] that controls the size and position
  /// of the modal.
  final DraggableScrollableController draggableScrollableController;

  /// The maximum height of the modal, occupying the full screen.
  static const double largeModalHeight = 1;

  /// The default medium height of the modal.
  static const double mediumModalHeight = .6;

  /// The minimum height of the modal when collapsed.
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
                onPointerUp: (_) => _verticalDragEnd(theme: theme),
                onPointerMove: (event) {
                  _verticalDragUpdate(event.delta.dy, event.position.dy);
                },
                onPointerCancel: (_) => _verticalDragEnd(theme: theme),
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

  /// Records the start position of a vertical drag gesture.
  ///
  /// Stores the initial y-coordinate of the pointer when dragging begins.
  void _verticalDragStart(double dragStartPosition) {
    _dragStart = dragStartPosition;
    _dragPosition = dragStartPosition;
  }

  /// Updates the modal height in response to the user's drag movement.
  ///
  /// Adjusts the [DraggableScrollableController] based on the drag delta,
  /// clamped between [smallModalHeight] and [largeModalHeight], and updates
  /// the current drag position.
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

  /// Handles completion of a vertical drag by animating to the nearest snap point.
  ///
  /// Determines drag direction and significance to animate the modal to
  /// either [largeModalHeight] or [smallModalHeight] with an easing curve.
  void _verticalDragEnd({required WebfabrikThemeData theme}) {
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
        duration: theme.durations.medium,
        curve: Curves.easeOut,
      );
    }
  }

  /// Returns the target modal height based on the drag direction.
  ///
  /// If dragging up, returns [largeModalHeight], otherwise returns [smallModalHeight].
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
