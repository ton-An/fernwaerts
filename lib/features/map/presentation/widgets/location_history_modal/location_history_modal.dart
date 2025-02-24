import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:location_history/core/misc/mock_location_history_items.dart';
import 'package:location_history/core/misc/number_formatter.dart';
import 'package:location_history/core/misc/time_date_formatter.dart';
import 'package:location_history/core/theme/location_history_theme.dart';
import 'package:location_history/core/widgets/dott.dart';
import 'package:location_history/core/widgets/gaps/gaps.dart';
import 'package:location_history/core/widgets/list_edge_fade.dart';
import 'package:location_history/core/widgets/small_icon_button.dart';
import 'package:location_history/features/map/domain/models/activity.dart';
import 'package:location_history/features/map/domain/models/place.dart';
import 'package:location_history/features/settings/pages/settings_page/settings_page.dart';

part '_activity_icon.dart';
part '_activity_list_item.dart';
part '_dotted_history_line.dart';
part '_header.dart';
part '_location_list.dart';
part '_modal_handle.dart';
part '_place_icon.dart';
part '_place_list_item.dart';
part '_vertical_list_item_divider.dart';

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
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(theme.radii.xLarge),
      ),
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
                    ],
                  ),
                ),
              ),
              Expanded(
                child: _LocationList(
                  scrollController: widget.scrollController,
                ),
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
    double currentExtent = widget.draggableScrollableController.size;

    double newExtent = (currentExtent -
            details.primaryDelta! / MediaQuery.of(context).size.height)
        .clamp(LocationHistoryModal.smallModalHeight,
            LocationHistoryModal.largeModalHeight);
    widget.draggableScrollableController.jumpTo(newExtent);
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
