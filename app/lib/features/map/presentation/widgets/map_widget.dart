import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:package_info_plus/package_info_plus.dart';

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

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(51.509364, -0.128928),
        initialZoom: 9.2,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: appPackageName ?? 'unknown',
        ),
      ],
    );
  }
}
