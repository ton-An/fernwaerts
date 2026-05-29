part of 'map_page.dart';

/// {@template location_markers}
/// The marker and polyline layer for the [MapPage].
///
/// It renders the full raw location path as polylines and highlights selected
/// inferred place boundary points with markers.
///
/// The marker color is interpolated across the timeline gradient. Direction
/// arrows are rendered separately for meaningful path movement, with a fallback
/// cadence so long dense paths still show direction.
/// {@endtemplate}
class _LocationMarkers extends StatelessWidget {
  /// {@macro location_markers}
  const _LocationMarkers({
    required this.markerPoints,
    required this.pathPoints,
  });

  final List<_LocationMarkerPoint> markerPoints;
  final List<LatLng> pathPoints;

  static const double _directionArrowDistanceThresholdInMeters = 50;
  static const int _maxLocationsBetweenDirectionArrows = 10;
  static const int _minimumDirectionDistanceInMeters = 5;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    final List<Marker> markers = _generateMarkers(
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
        MarkerLayer(markers: [...arrowMarkers, ...markers]),
      ],
    );
  }

  /// Builds highlighted markers for the current [markerPoints].
  List<Marker> _generateMarkers({required List<Color> gradientColors}) {
    final List<Marker> markers = [];

    for (final _LocationMarkerPoint markerPoint in markerPoints) {
      final int pathIndex = _pathIndexForPoint(markerPoint.point);

      if (pathIndex < 0) {
        continue;
      }

      final Color markerColor = _interpolateColors(
        gradientColors,
        pathIndex / pathPoints.length,
      );

      markers.add(
        _SingleLocationMarker(point: markerPoint.point, color: markerColor),
      );
    }

    return markers;
  }

  int _pathIndexForPoint(LatLng point) {
    return pathPoints.indexWhere(
      (LatLng pathPoint) =>
          pathPoint.latitude == point.latitude &&
          pathPoint.longitude == point.longitude,
    );
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

      final Color arrowColor = _directionArrowColor(
        _interpolateColors(gradientColors, i / pathPoints.length),
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

    for (int i = 0; i < pathPoints.length; i++) {
      final bool isLastPoint = i == pathPoints.length - 1;
      if (!isLastPoint) {
        final Color pathColor = _interpolateColors(
          gradientColors,
          i / pathPoints.length,
        );

        polylines.add(
          Polyline(
            points: [pathPoints[i], pathPoints[i + 1]],
            color: pathColor.withValues(alpha: .6),
            strokeWidth: 14,
          ),
        );
      }
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

  /// Interpolates the timeline marker color for position [t].
  Color _interpolateColors(List<Color> colors, double t) {
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

class _LocationMarkerPoint {
  const _LocationMarkerPoint({required this.point});

  final LatLng point;
}
