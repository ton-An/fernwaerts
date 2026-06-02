part of 'map_page.dart';

/* 
  To-Do:
    - [ ] Tune arrow offset and rotation accuracy over long distances
*/

/// {@template location_history_layer}
/// The path, direction, and place marker layer for the [MapPage].
///
/// It renders the full raw location path as polylines and highlights selected
/// inferred place boundary points with markers.
///
/// The marker color is interpolated across the timeline gradient. Direction
/// arrows are rendered separately for meaningful path movement, with a fallback
/// cadence so long dense paths still show direction.
/// {@endtemplate}
class _LocationHistoryLayer extends StatelessWidget {
  /// {@macro location_history_layer}
  const _LocationHistoryLayer({
    required this.placeMarkers,
    required this.pathPoints,
  });

  static const double _directionArrowDistanceThresholdInMeters = 50;
  static const int _maxLocationsBetweenDirectionArrows = 10;
  static const double _minimumDirectionDistanceInMeters = 5;
  static const double _pathStrokeWidth = 14;
  static const double _pathOpacity = .6;

  final List<_PlaceBoundaryMarkerData> placeMarkers;
  final List<LatLng> pathPoints;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    final List<Marker> placeMarkerWidgets = _generatePlaceMarkers(
      gradientColors: theme.colors.timelineGradient,
    );
    final List<Marker> arrowMarkers = _generateDirectionArrowMarkers(
      gradientColors: theme.colors.timelineGradient,
    );
    final List<Polyline> polylines = _generatePolylines(
      gradientColors: theme.colors.timelineGradient,
    );

    return Stack(
      children: [
        PolylineLayer(polylines: polylines),
        MarkerLayer(markers: [...arrowMarkers, ...placeMarkerWidgets]),
      ],
    );
  }

  /// Builds highlighted markers for the current [placeMarkers].
  List<Marker> _generatePlaceMarkers({required List<Color> gradientColors}) {
    return [
      for (final _PlaceBoundaryMarkerData placeMarker in placeMarkers)
        _PlaceMarker(
          point: placeMarker.point,
          color: _timelineColor(gradientColors, placeMarker.timelinePosition),
        ),
    ];
  }

  List<Marker> _generateDirectionArrowMarkers({
    required List<Color> gradientColors,
  }) {
    final List<Marker> arrows = [];
    int lastArrowIndex = 0;

    for (int i = 0; i < pathPoints.length - 1; i++) {
      final LatLng point = pathPoints[i];
      final LatLng nextPoint = pathPoints[i + 1];
      final double distanceToNextPoint = _distanceInMeters(
        point: point,
        nextPoint: nextPoint,
      );

      if (distanceToNextPoint < _minimumDirectionDistanceInMeters) {
        continue;
      }

      final bool exceedsDistanceThreshold =
          distanceToNextPoint > _directionArrowDistanceThresholdInMeters;
      final bool reachedFallbackCadence =
          i - lastArrowIndex >= _maxLocationsBetweenDirectionArrows;

      if (!exceedsDistanceThreshold && !reachedFallbackCadence) {
        continue;
      }

      final Color arrowColor = _directionArrowMarkerColor(
        _timelineColor(gradientColors, i / pathPoints.length),
      );

      arrows.add(
        _DirectionArrowMarker(
          point: point,
          rotation: _calculateAngleToNextPoint(
            point: point,
            nextPoint: nextPoint,
          ),
          color: arrowColor,
        ),
      );
      lastArrowIndex = i;
    }

    return arrows;
  }

  /// Builds the raw location path for the current [pathPoints].
  List<Polyline> _generatePolylines({required List<Color> gradientColors}) {
    final List<Polyline> polylines = [];

    for (int i = 0; i < pathPoints.length - 1; i++) {
      final Color pathColor = _timelineColor(
        gradientColors,
        i / pathPoints.length,
      );

      polylines.add(
        Polyline(
          points: [pathPoints[i], pathPoints[i + 1]],
          color: pathColor.withValues(alpha: _pathOpacity),
          strokeWidth: _pathStrokeWidth,
        ),
      );
    }

    return polylines;
  }

  /// Calculates the rotation angle from [point] to [nextPoint].
  double _calculateAngleToNextPoint({
    required LatLng point,
    required LatLng nextPoint,
  }) {
    const Distance distanceUtils = Distance();

    // Distance.bearing returns the heading clockwise from north, in degrees.
    final double bearingDeg = distanceUtils.bearing(point, nextPoint);

    // Transform.rotate expects radians.
    final double bearingRad = bearingDeg * (pi / 180);

    // Keep the rotation in the range expected by the marker transform.
    return (bearingRad + 2 * pi) % (2 * pi);
  }

  double _distanceInMeters({required LatLng point, required LatLng nextPoint}) {
    const Distance distanceUtils = Distance();

    return distanceUtils.as(LengthUnit.Meter, point, nextPoint);
  }

  /// Interpolates the timeline color for position [t].
  Color _timelineColor(List<Color> colors, double t) {
    if (colors.length == 1 || t <= 0) return colors.first;
    if (t >= 1) return colors.last;

    final segmentLength = 1 / (colors.length - 1);
    final segmentIndex = (t / segmentLength).floor();
    final localT = (t - (segmentIndex * segmentLength)) / segmentLength;

    final colorStart = colors[segmentIndex];
    final colorEnd = colors[segmentIndex + 1];

    Color color = Color.lerp(colorStart, colorEnd, localT)!;

    return color;
  }
}

/// A place marker paired with its fractional position along the timeline
/// gradient, in the range 0 to 1.
typedef _PlaceBoundaryMarkerData = ({LatLng point, double timelinePosition});
