part of 'map_page.dart';

/* 
  To-Do:
    - [ ] Improve arrowOffsetDirection as it doesn't seem accurate over long distances
*/

/// The core map component of the [MapPage].
///
/// It renders the base map, listens to [MapCubit] for loaded locations, converts
/// those locations into map points, and delegates marker rendering to
/// [_LocationMarkers].
class _Map extends StatefulWidget {
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

  /// Loads the package name used as the map tile user agent.
  Future<void> _setAppPackageName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    appPackageName = packageInfo.packageName;
  }

  /// Updates the displayed map points or reports map-loading failures.
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
