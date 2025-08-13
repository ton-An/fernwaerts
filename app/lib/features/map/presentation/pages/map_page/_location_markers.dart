part of 'map_page.dart';

class _LocationMarkers extends StatelessWidget {
  const _LocationMarkers({required this.points});

  final List<LatLng> points;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    final (List<Marker>, List<Polyline>) points = _generateMarkers(
      gradientColors: theme.colors.timelineGradient,
    );

    final List<Marker> markers = points.$1.reversed.toList();
    final List<Polyline> polylines = points.$2;

    return Stack(
      children: [
        PolylineLayer(polylines: polylines),
        MarkerLayer(markers: markers.reversed.toList()),
      ],
    );
  }

  (List<Marker>, List<Polyline>) _generateMarkers({
    required List<Color> gradientColors,
  }) {
    final List<Marker> markers = [];
    final List<Polyline> polylines = [];

    for (int i = 0; i < points.length; i++) {
      final bool isLastPoint = i == points.length - 1;

      double? angleToNextPoint;
      Offset? arrowOffset;

      if (!isLastPoint) {
        angleToNextPoint = _calculateAngleToNextPoint(
          point: points[i],
          nextPoint: points[i + 1],
        );

        arrowOffset = Offset.fromDirection(angleToNextPoint - pi / 2, 20);
      }

      final Color markerColor = _interpolateColors(
        gradientColors,
        i / points.length,
      );

      final bool isNextPointIdentical =
          isLastPoint
              ? true
              : _isNextPointIdentical(
                point: points[i],
                nextPoint: points[i + 1],
              );

      markers.add(
        _SingleLocationMarker(
          point: points[i],
          arrowOffset: arrowOffset,
          arrowRotation: angleToNextPoint,
          color: markerColor,
          displayArrow: !isNextPointIdentical,
        ),
      );

      if (!isLastPoint) {
        polylines.add(
          Polyline(
            points: [points[i], points[i + 1]],
            color: markerColor.withValues(alpha: .6),
            strokeWidth: 14,
          ),
        );
      }
    }

    return (markers, polylines);
  }

  double _calculateAngleToNextPoint({
    required LatLng point,
    required LatLng nextPoint,
  }) {
    const Distance distanceUtils = Distance();

    // Distance.bearing() gives you the heading clockwise from North, in degrees.
    final double bearingDeg = distanceUtils.bearing(point, nextPoint);

    // Convert degrees → radians for Transform.rotate
    final double bearingRad = bearingDeg * (pi / 180);

    // Normalize to 0 .. 2π
    return (bearingRad + 2 * pi) % (2 * pi);
  }

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
