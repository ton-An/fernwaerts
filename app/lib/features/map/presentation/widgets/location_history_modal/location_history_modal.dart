import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:location_history/core/l10n/app_localizations.dart';
import 'package:location_history/core/misc/number_formatter.dart';
import 'package:location_history/features/location_tracking/domain/enums/activity_type.dart';
import 'package:location_history/features/location_tracking/domain/models/activity_segment.dart';
import 'package:location_history/features/location_tracking/domain/models/location.dart';
import 'package:location_history/features/map/domain/models/place.dart';
import 'package:location_history/features/map/presentation/cubits/map_animation_cubit.dart';
import 'package:location_history/features/map/presentation/cubits/map_cubit.dart';
import 'package:location_history/features/map/presentation/cubits/map_state.dart';
import 'package:location_history/features/settings/presentation/pages/main_settings_page/main_settings_page.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

part '_activity_icon.dart';
part '_activity_segment_list_item.dart';
part '_dotted_history_line.dart';
part '_empty_list.dart';
part '_header.dart';
part '_location_list.dart';
part '_location_list_item.dart';
part '_modal_handle.dart';
part '_place_icon.dart';
part '_place_list_item.dart';

/* To-Do:
    - [ ] Factor in velocity of drag to determine if a drag was significant
    - [ ] Fix onPointerUp sometimes not being called on some simulator devices
*/

/// {@template location_history_modal}
/// Displays the selected location history in a draggable bottom sheet.
///
/// The parent owns the [DraggableScrollableController]; this widget uses it to
/// react to drag gestures on the header and snap between collapsed and expanded
/// heights.
///
/// Sub-components:
/// - [_Header]: Shows the history title and page actions.
/// - [_LocationList]: Renders the current [MapCubit] locations.
/// {@endtemplate}
class LocationHistoryModal extends StatefulWidget {
  /// {@macro location_history_modal}
  const LocationHistoryModal({
    super.key,
    required this.scrollController,
    required this.draggableScrollableController,
  });

  /// Coordinates list scrolling with the surrounding [DraggableScrollableSheet].
  final ScrollController scrollController;

  /// Controls the sheet extent shared with the parent modal section.
  final DraggableScrollableController draggableScrollableController;

  /// Expanded sheet extent.
  static const double largeModalHeight = 1;

  /// Initial sheet extent.
  static const double mediumModalHeight = .6;

  /// Collapsed sheet extent.
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

  /// Stores the pointer position used to calculate header drag distance.
  void _verticalDragStart(double dragStartPosition) {
    _dragStart = dragStartPosition;
    _dragPosition = dragStartPosition;
  }

  /// Moves the sheet with the header drag while keeping it within valid extents.
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

  /// Snaps the sheet to an expanded or collapsed extent after a header drag.
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

  /// Resolves the snap extent for the completed drag direction.
  double _getModalHeight(VerticalDirection dragDirection) {
    if (dragDirection == VerticalDirection.up) {
      return LocationHistoryModal.largeModalHeight;
    } else {
      return LocationHistoryModal.smallModalHeight;
    }
  }
}

/// Vertical drag direction used to decide how the modal should snap.
enum VerticalDirection {
  up,
  down;

  /// Returns the opposite vertical direction.
  VerticalDirection flip() {
    if (this == VerticalDirection.up) {
      return VerticalDirection.down;
    } else {
      return VerticalDirection.up;
    }
  }
}
