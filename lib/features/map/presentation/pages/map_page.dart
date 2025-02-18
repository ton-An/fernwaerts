import 'package:flutter/cupertino.dart';
import 'package:location_history/core/theme/location_history_theme.dart';
import 'package:location_history/features/calendar/presentation/widgets/calendar_stepper/calendar_stepper.dart';
import 'package:location_history/features/map/presentation/widgets/map_widget.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  static const String pageName = "map";
  static const String route = "/$pageName";

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: MapWidget(),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: SafeArea(
              child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: LocationHistoryTheme.of(context).spacing.medium),
            child: CalendarStepper(),
          )),
        ),
      ],
    );
  }
}
