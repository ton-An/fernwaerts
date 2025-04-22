import 'package:flutter/material.dart';
import 'package:maplibre/maplibre.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  String? appPackageName;

  @override
  void initState() {
    super.initState();

    _setAppPackageName();
  }

  Future<void> _setAppPackageName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      appPackageName = packageInfo.packageName;
    });
  }

  final _points = <Point>[
    Point(coordinates: Position(9.17, 47.68)),
    Point(coordinates: Position(9.17, 48)),
    Point(coordinates: Position(9, 48)),
    Point(coordinates: Position(9.5, 48)),
  ];

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return MapLibreMap(
      acceptLicense: true,
      options: const MapOptions(
        initStyle:
            'https://raw.githubusercontent.com/ton-An/tilekiln-shortbread-demo/refs/heads/main/colorful.json',
      ),
      layers: [
        CircleLayer(
          points: _points,
          radius: 5,
          blur: .6,
          strokeWidth: 4,
          color: theme.colors.primary,
          strokeColor: theme.colors.primaryTranslucent,
        ),
      ],
    );

    // return FlutterMap(
    //   options: const MapOptions(
    //     initialCenter: LatLng(51.509364, -0.128928),
    //     initialZoom: 9.2,
    //   ),
    //   children: [
    //     TileLayer(
    //       urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    //       userAgentPackageName: appPackageName ?? 'unknown',
    //     ),
    //     CircleLayer(
    //       circles: [
    //         CircleMarker(
    //           point: LatLng(51.509364, -0.128928),
    //           radius: 10,
    //           color: theme.colors.primary,
    //           borderStrokeWidth: 25,
    //           borderColor: theme.colors.primaryTranslucent,
    //         ),
    //       ],
    //     ),
    //   ],
    // );
  }
}
// 