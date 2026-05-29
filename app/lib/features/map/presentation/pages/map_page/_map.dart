part of 'map_page.dart';

/// {@template map_page_map}
/// The core map component of the [MapPage].
///
/// It renders OpenStreetMap tiles, listens to [MapCubit], converts loaded
/// locations into map coordinates, and delegates marker rendering to
/// [_LocationHistoryLayer].
/// {@endtemplate}
class _Map extends StatefulWidget {
  /// {@macro map_page_map}
  const _Map();

  @override
  State<_Map> createState() => _MapState();
}

class _MapState extends State<_Map> with SingleTickerProviderStateMixin {
  static const double _minFocusZoom = 12;

  late final MapController _mapController;
  late final AnimationController _mapAnimationController;

  String? _appPackageName;

  List<LatLng> _pathPoints = [];
  List<_PlaceTimelineMarker> _placeMarkers = [];
  _CameraAnimation? _cameraAnimation;

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
            userAgentPackageName: _appPackageName ?? 'location_history',
          ),

          _LocationHistoryLayer(
            placeMarkers: _placeMarkers,
            pathPoints: _pathPoints,
          ),
        ],
      ),
    );
  }

  /// Loads the package name used by the OpenStreetMap tile user agent.
  Future<void> _setAppPackageName() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    if (!mounted) {
      return;
    }

    setState(() {
      _appPackageName = packageInfo.packageName;
    });
  }

  /// Updates displayed points or forwards map-loading failures to notifications.
  void _mapCubitListener(BuildContext context, MapState mapState) {
    if (mapState is MapLocationsLoaded) {
      setState(() {
        _pathPoints = _pathPointsFrom(mapState.locations);
        _placeMarkers = _placeTimelineMarkers(
          activitySegments: mapState.activitySegments,
          locations: mapState.locations,
        );
      });
    }

    if (mapState is MapLocationsError) {
      context.read<InAppNotificationCubit>().sendFailureNotification(
        mapState.failure,
      );
    }
  }

  List<LatLng> _pathPointsFrom(List<Location> locations) {
    return [
      for (final Location location in locations)
        LatLng(location.latitude, location.longitude),
    ];
  }

  /// Builds a marker for each inferred place, colored by its position along the
  /// timeline gradient.
  List<_PlaceTimelineMarker> _placeTimelineMarkers({
    required List<ActivitySegment> activitySegments,
    required List<Location> locations,
  }) {
    if (activitySegments.isEmpty || locations.isEmpty) {
      return [];
    }

    final Map<String, int> indexById = {
      for (int i = 0; i < locations.length; i++) locations[i].id: i,
    };

    final List<_PlaceTimelineMarker> placeMarkers = [];
    for (final String locationId in activitySegments.boundaryLocationIds) {
      final int? index = indexById[locationId];
      if (index == null) {
        continue;
      }

      final Location location = locations[index];
      placeMarkers.add((
        point: LatLng(location.latitude, location.longitude),
        timelinePosition: index / locations.length,
      ));
    }

    return placeMarkers;
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
    final double startZoom = _mapController.camera.zoom;

    _cameraAnimation = _CameraAnimation(
      start: _mapController.camera.center,
      end: LatLng(location.latitude, location.longitude),
      startZoom: startZoom,
      endZoom: math.max(startZoom, _minFocusZoom),
    );

    _mapAnimationController.duration = theme.durations.medium;
    _mapAnimationController.forward(from: 0);
  }

  void _moveMapWithAnimation() {
    final _CameraAnimation? animation = _cameraAnimation;

    if (animation == null) {
      return;
    }

    final double t = Curves.easeInOut.transform(_mapAnimationController.value);

    _mapController.move(animation.centerAt(t), animation.zoomAt(t));
  }
}

/// Linear interpolation between two map camera positions.
class _CameraAnimation {
  const _CameraAnimation({
    required this.start,
    required this.end,
    required this.startZoom,
    required this.endZoom,
  });

  final LatLng start;
  final LatLng end;
  final double startZoom;
  final double endZoom;

  LatLng centerAt(double t) {
    return LatLng(
      start.latitude + (end.latitude - start.latitude) * t,
      start.longitude + (end.longitude - start.longitude) * t,
    );
  }

  double zoomAt(double t) => startZoom + (endZoom - startZoom) * t;
}
