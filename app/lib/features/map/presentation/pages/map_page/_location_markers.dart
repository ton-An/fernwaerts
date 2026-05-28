part of 'map_page.dart';

/// {@template location_markers}
/// The marker and polyline layer for the [MapPage].
///
/// It renders the full raw location path as polylines and highlights selected
/// segment endpoints with markers.
///
/// The marker color is interpolated across the timeline gradient and each
/// marker, except the final point or points that are nearly identical, gets a
/// direction arrow toward the next point.
/// {@endtemplate}
class _LocationMarkers extends StatelessWidget {
  /// {@macro location_markers}
  const _LocationMarkers({
    required this.markerPoints,
    required this.pathPoints,
  });

  final List<_SegmentEndpointMarker> markerPoints;
  final List<LatLng> pathPoints;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    final List<Marker> markers = _generateMarkers(
      gradientColors: theme.colors.timelineGradient,
    );
    final List<Polyline> polylines = _generatePolylines(
      gradientColors: theme.colors.timelineGradient,
    );

    return Stack(
      children: [
        PolylineLayer(polylines: polylines),
        MarkerLayer(markers: markers),
      ],
    );
  }

  /// Builds highlighted markers for the current [markerPoints].
  List<Marker> _generateMarkers({required List<Color> gradientColors}) {
    final List<Marker> markers = [];

    for (int i = 0; i < markerPoints.length; i++) {
      final _SegmentEndpointMarker markerPoint = markerPoints[i];

      double? arrowRotation;
      Offset? arrowOffset;

      final LatLng? nextPathPoint = _getNextPathPoint(markerPoint.point);

      if (nextPathPoint != null) {
        arrowRotation = _calculateAngleToNextPoint(
          point: markerPoint.point,
          nextPoint: nextPathPoint,
        );

        arrowOffset = Offset.fromDirection(arrowRotation - pi / 2, 20);
      }

      final Color markerColor = _interpolateColors(
        gradientColors,
        i / markerPoints.length,
      );

      final bool isNextPointIdentical =
          nextPathPoint == null
              ? true
              : _isNextPointIdentical(
                point: markerPoint.point,
                nextPoint: nextPathPoint,
              );

      markers.add(
        _SingleLocationMarker(
          point: markerPoint.point,
          arrowOffset: arrowOffset,
          arrowRotation: arrowRotation,
          color: markerColor,
          displayArrow: !isNextPointIdentical,
          type: markerPoint.type,
        ),
      );
    }

    return markers;
  }

  LatLng? _getNextPathPoint(LatLng markerPoint) {
    final int pathIndex = pathPoints.indexWhere(
      (LatLng pathPoint) =>
          pathPoint.latitude == markerPoint.latitude &&
          pathPoint.longitude == markerPoint.longitude,
    );

    if (pathIndex < 0 || pathIndex >= pathPoints.length - 1) {
      return null;
    }

    return pathPoints[pathIndex + 1];
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

  /// Whether [nextPoint] is close enough to [point] to hide the direction arrow.
  bool _isNextPointIdentical({
    required LatLng point,
    required LatLng nextPoint,
  }) {
    const Distance distanceUtils = Distance();

    final double distance = distanceUtils.as(
      LengthUnit.Meter,
      point,
      nextPoint,
    );

    const int minDistanceInMeters = 5;

    return distance < minDistanceInMeters;
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

class _SegmentEndpointMarker {
  const _SegmentEndpointMarker({required this.point, required this.type});

  final LatLng point;
  final _SegmentEndpointMarkerType type;
}

enum _SegmentEndpointMarkerType { start, end }
