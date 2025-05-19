part of 'map_page.dart';

/* 
  To-Do:
    - [ ] Improve arrowOffsetDirection as it doesn't seem accurate over long distances
*/
class _MapWidget extends StatefulWidget {
  const _MapWidget();

  @override
  State<_MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<_MapWidget> {
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
          _MapLocationMarkers(points: _points),
          // ToDo: remove after may 15th + 1 month - keep for debugging until then
          // MarkerLayer(
          //   markers: [
          //     for (int i = 0; i < _points.length; i++)
          //       Marker(
          //         width: 24,
          //         height: 24,
          //         point: _points[i],
          //         child: Padding(
          //           padding: EdgeInsets.only(
          //             top: Random().nextInt(12).toDouble(),
          //           ),
          //           child: Text(i.toString(), style: TextStyle(fontSize: 10)),
          //         ),
          //       ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Future<void> _setAppPackageName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    appPackageName = packageInfo.packageName;
  }

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
