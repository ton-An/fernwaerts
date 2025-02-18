import 'package:flutter/cupertino.dart';
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
      ],
    );
  }
}
