part of 'map_page.dart';

/* 
  To-Do:
    - [ ] Tune arrow offset and rotation accuracy over long distances
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

class _MapState extends State<_Map> with SingleTickerProviderStateMixin {
  late final MapController _mapController;
  late final AnimationController _mapAnimationController;

  String? appPackageName;

  List<LatLng> _pathPoints = [];
  List<_SegmentEndpointMarker> _markerPoints = [];
  LatLng? _animationStartCenter;
  LatLng? _animationTarget;
  double? _animationStartZoom;
  double? _animationTargetZoom;

  @override
  void initState() {
    super.initState();

    _mapController = MapController();
    _mapAnimationController = AnimationController(vsync: this)
      ..addListener(_moveMapWithAnimation);

    _setAppPackageName();
  }

  @override
  void dispose() {
    _mapAnimationController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MapCubit, MapState>(listener: _mapCubitListener),
        BlocListener<MapAnimationCubit, MapAnimationState>(
          listener: _mapAnimationCubitListener,
        ),
      ],
      child: FlutterMap(
        mapController: _mapController,
        options: const MapOptions(
          initialCenter: LatLng(50.14568, 9.96024),
          initialZoom: 6,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: appPackageName ?? 'location_history',
          ),

          _LocationMarkers(
            markerPoints: _markerPoints,
            pathPoints: _pathPoints,
          ),
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
      final Map<String, Location> locationsById = {
        for (final Location location in mapState.locations)
          location.id: location,
      };
      final List<LatLng> pathPoints = [
        for (final Location location in mapState.locations)
          LatLng(location.latitude, location.longitude),
      ];
      final List<_SegmentEndpointMarker> markerPoints = [];

      for (final activitySegment in mapState.activitySegments) {
        final Location? startLocation =
            locationsById[activitySegment.startLocationId];
        final Location? endLocation =
            locationsById[activitySegment.endLocationId];

        if (startLocation == null || endLocation == null) {
          continue;
        }

        markerPoints.add(
          _SegmentEndpointMarker(
            point: LatLng(startLocation.latitude, startLocation.longitude),
            type: _SegmentEndpointMarkerType.start,
          ),
        );
        markerPoints.add(
          _SegmentEndpointMarker(
            point: LatLng(endLocation.latitude, endLocation.longitude),
            type: _SegmentEndpointMarkerType.end,
          ),
        );
      }

      setState(() {
        _pathPoints = pathPoints;
        _markerPoints = markerPoints;
      });
    }

    if (mapState is MapLocationsError) {
      context.read<InAppNotificationCubit>().sendFailureNotification(
        mapState.failure,
      );
    }
  }

  void _mapAnimationCubitListener(
    BuildContext context,
    MapAnimationState mapAnimationState,
  ) {
    if (mapAnimationState is MapLocationAnimationRequested) {
      _animateToLocation(
        location: mapAnimationState.location,
        theme: WebfabrikTheme.of(context),
      );
    }
  }

  void _animateToLocation({
    required Location location,
    required WebfabrikThemeData theme,
  }) {
    final LatLng target = LatLng(location.latitude, location.longitude);
    final double startZoom = _mapController.camera.zoom;

    _animationStartCenter = _mapController.camera.center;
    _animationTarget = target;
    _animationStartZoom = startZoom;
    _animationTargetZoom = startZoom < 12 ? 12 : startZoom;

    _mapAnimationController.duration = theme.durations.medium;
    _mapAnimationController.forward(from: 0);
  }

  void _moveMapWithAnimation() {
    final LatLng? startCenter = _animationStartCenter;
    final LatLng? target = _animationTarget;
    final double? startZoom = _animationStartZoom;
    final double? targetZoom = _animationTargetZoom;

    if (startCenter == null ||
        target == null ||
        startZoom == null ||
        targetZoom == null) {
      return;
    }

    final double value = Curves.easeInOut.transform(
      _mapAnimationController.value,
    );
    final double latitude =
        startCenter.latitude + (target.latitude - startCenter.latitude) * value;
    final double longitude =
        startCenter.longitude +
        (target.longitude - startCenter.longitude) * value;
    final double zoom = startZoom + (targetZoom - startZoom) * value;

    _mapController.move(LatLng(latitude, longitude), zoom);
  }
}
