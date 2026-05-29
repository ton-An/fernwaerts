part of 'map_page.dart';

/// {@template single_location_marker}
/// A circular timeline marker for an inferred location or place point.
/// {@endtemplate}
class _SingleLocationMarker extends Marker {
  /// {@macro single_location_marker}
  _SingleLocationMarker({required super.point, required Color color})
    : super(
        width: 38,
        height: 38,
        child: Center(
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: .22),
                  blurRadius: 0,
                  spreadRadius: 6,
                ),
              ],
            ),
            child: Icon(
              Icons.place,
              size: 19,
              color: Colors.white.withValues(alpha: .92),
            ),
          ),
        ),
      );
}

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
         width: 30,
         height: 30,
         child: Center(
           child: Transform.rotate(
             angle: rotation,
             child: CustomPaint(
               size: const Size(24, 26),
               painter: _DirectionArrowPainter(color: color),
             ),
           ),
         ),
       );
}

class _DirectionArrowPainter extends CustomPainter {
  const _DirectionArrowPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final ui.Path arrow = _roundedTrianglePath(size);

    canvas.drawShadow(arrow, Colors.black.withValues(alpha: .22), 2, true);

    final Paint fillPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    canvas.drawPath(arrow, fillPaint);
  }

  ui.Path _roundedTrianglePath(Size size) {
    final List<Offset> points = [
      Offset(size.width / 2, size.height * .08),
      Offset(size.width * .84, size.height * .86),
      Offset(size.width * .16, size.height * .86),
    ];
    const double radius = 2.5;

    final ui.Path path = ui.Path();

    for (int i = 0; i < points.length; i++) {
      final Offset point = points[i];
      final Offset previous = points[(i - 1 + points.length) % points.length];
      final Offset next = points[(i + 1) % points.length];
      final Offset start = _pointTowards(
        from: point,
        to: previous,
        distance: radius,
      );
      final Offset end = _pointTowards(from: point, to: next, distance: radius);

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
  bool shouldRepaint(_DirectionArrowPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

Color _directionArrowColor(Color color) {
  final HSLColor hslColor = HSLColor.fromColor(color);

  const double lightnessChangeAmount = .15;

  final bool isDark = hslColor.lightness < 0.5;
  final double adjustedLightness = (isDark
          ? hslColor.lightness + lightnessChangeAmount
          : hslColor.lightness - lightnessChangeAmount)
      .clamp(0.0, 1.0);

  return hslColor.withLightness(adjustedLightness).toColor();
}
