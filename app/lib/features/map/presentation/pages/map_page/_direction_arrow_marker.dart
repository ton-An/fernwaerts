part of 'map_page.dart';

/// {@template direction_arrow_marker}
/// Direction-only path marker for sampled raw location points.
/// {@endtemplate}
class _DirectionArrowMarker extends Marker {
  /// {@macro direction_arrow_marker}
  _DirectionArrowMarker({
    required super.point,
    required double rotation,
    required Color color,
  }) : super(
         width: _markerSize,
         height: _markerSize,
         child: Center(
           child: Transform.rotate(
             angle: rotation,
             child: CustomPaint(
               size: const Size(_arrowWidth, _arrowHeight),
               painter: _DirectionArrowShapePainter(color: color),
             ),
           ),
         ),
       );

  static const double _markerSize = 30;
  static const double _arrowWidth = 24;
  static const double _arrowHeight = 26;
}

class _DirectionArrowShapePainter extends CustomPainter {
  const _DirectionArrowShapePainter({required this.color});

  static const double _tipYFraction = .08;
  static const double _baseYFraction = .86;
  static const double _baseXInset = .16;
  static const double _cornerRadius = 2.5;
  static const double _shadowOpacity = .22;
  static const double _shadowElevation = 2;

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final ui.Path arrow = _roundedTrianglePath(size);

    canvas.drawShadow(
      arrow,
      Colors.black.withValues(alpha: _shadowOpacity),
      _shadowElevation,
      true,
    );

    final Paint fillPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    canvas.drawPath(arrow, fillPaint);
  }

  ui.Path _roundedTrianglePath(Size size) {
    final List<Offset> points = [
      Offset(size.width / 2, size.height * _tipYFraction),
      Offset(size.width * (1 - _baseXInset), size.height * _baseYFraction),
      Offset(size.width * _baseXInset, size.height * _baseYFraction),
    ];

    final ui.Path path = ui.Path();

    for (int i = 0; i < points.length; i++) {
      final Offset point = points[i];
      final Offset previous = points[(i - 1 + points.length) % points.length];
      final Offset next = points[(i + 1) % points.length];
      final Offset start = _pointTowards(
        from: point,
        to: previous,
        distance: _cornerRadius,
      );
      final Offset end = _pointTowards(
        from: point,
        to: next,
        distance: _cornerRadius,
      );

      if (i == 0) {
        path.moveTo(start.dx, start.dy);
      } else {
        path.lineTo(start.dx, start.dy);
      }

      path.quadraticBezierTo(point.dx, point.dy, end.dx, end.dy);
    }

    return path..close();
  }

  Offset _pointTowards({
    required Offset from,
    required Offset to,
    required double distance,
  }) {
    final Offset delta = to - from;
    final double length = math.sqrt(delta.dx * delta.dx + delta.dy * delta.dy);

    return Offset(
      from.dx + delta.dx / length * distance,
      from.dy + delta.dy / length * distance,
    );
  }

  @override
  bool shouldRepaint(_DirectionArrowShapePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

Color _directionArrowMarkerColor(Color color) {
  const double darkLightnessThreshold = .5;
  const double lightnessChangeAmount = .15;

  final HSLColor hslColor = HSLColor.fromColor(color);
  final bool isDark = hslColor.lightness < darkLightnessThreshold;
  final double adjustedLightness = (isDark
          ? hslColor.lightness + lightnessChangeAmount
          : hslColor.lightness - lightnessChangeAmount)
      .clamp(0.0, 1.0);

  return hslColor.withLightness(adjustedLightness).toColor();
}
