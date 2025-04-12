import 'package:flutter/material.dart';
import 'package:location_history/core/l10n/app_localizations.dart';
import 'package:location_history/features/calendar/presentation/widgets/calendar_composite/calendar_composite.dart';
import 'package:location_history/features/map/presentation/widgets/location_history_modal/location_history_modal.dart';
import 'package:location_history/features/map/presentation/widgets/map_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

part '_map_attribution.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  static const String pageName = 'map';
  static const String route = '/$pageName';

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
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
    return Stack(
      children: [
        const Positioned.fill(child: MapWidget()),
        Column(
          children: [
            SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: WebfabrikTheme.of(context).spacing.medium,
                ),
                child: const CalendarComposite(),
              ),
            ),
            Expanded(
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
                snapAnimationDuration: const Duration(milliseconds: 300),
                builder:
                    (context, scrollController) => Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _MapAttribution(
                          draggableScrollableController:
                              _draggableScrollableController,
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
            ),
          ],
        ),
      ],
    );
  }
}
