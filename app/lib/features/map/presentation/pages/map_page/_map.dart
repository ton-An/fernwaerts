part of 'map_page.dart';

/* 
  To-Do:
    - [ ] Improve arrowOffsetDirection as it doesn't seem accurate over long distances
*/

/// {@template map_page_map}
/// The core map component of the [MapPage].
///
/// It renders OpenStreetMap tiles, listens to [MapCubit], converts loaded
/// locations into map coordinates, and delegates marker rendering to
/// [_LocationMarkers].
/// {@endtemplate}
class _Map extends StatefulWidget {
  /// {@macro map_page_map}
  const _Map();

  @override
  State<_Map> createState() => _MapState();
}

class _MapState extends State<_Map> {
  String? appPackageName;

  List<LatLng> _points = [];

  @override
  void initState() {
    super.initState();

    _setAppPackageName();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MapCubit, MapState>(
      listener: _mapCubitListener,
      child: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(50.14568, 9.96024),
          initialZoom: 6,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: appPackageName ?? 'location_history',
          ),

          _LocationMarkers(points: _points),
        ],
      ),
    );
  }

  /// Loads the package name used by the OpenStreetMap tile user agent.
  Future<void> _setAppPackageName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    appPackageName = packageInfo.packageName;
  }

  /// Updates displayed points or forwards map-loading failures to notifications.
  void _mapCubitListener(BuildContext context, MapState mapState) {
    if (mapState is MapLocationsLoaded) {
      final points = <LatLng>[];

      for (final location in mapState.locations) {
        points.add(
          LatLng(location.latitude.toDouble(), location.longitude.toDouble()),
        );
      }

      setState(() {
        _points = points;
      });
    }

    if (mapState is MapLocationsError) {
      context.read<InAppNotificationCubit>().sendFailureNotification(
        mapState.failure,
      );
    }
  }
}
