part of 'map_page.dart';

/// {@template single_location_marker}
/// A timeline marker with an optional directional arrow to the next point.
/// {@endtemplate}
class _SingleLocationMarker extends Marker {
  /// {@macro single_location_marker}
  _SingleLocationMarker({
    required super.point,
    required Offset? arrowOffset,
    required double? arrowRotation,
    required Color color,
    required bool displayArrow,
    required _SegmentEndpointMarkerType type,
  }) : super(
         width: 38,
         height: 38,
         child: Stack(
           clipBehavior: Clip.none,
           children: [
             Center(
               child: CustomPaint(
                 size: const Size(30, 34),
                 painter: _SegmentEndpointMarkerPainter(
                   color: color,
                   type: type,
                 ),
               ),
             ),

             if (displayArrow)
               Center(
                 child: Transform.translate(
                   offset: arrowOffset ?? Offset.zero,
                   child: Transform.rotate(
                     angle: arrowRotation ?? 0,
                     child: OverflowBox(
                       maxWidth: double.infinity,
                       maxHeight: double.infinity,
                       alignment: Alignment.center,
                       child: Center(
                         child: Builder(
                           builder: (context) {
                             final HSLColor hslColor = HSLColor.fromColor(
                               color,
                             );

                             const double lightnessChangeAmount = .15;

                             final bool isDark = hslColor.lightness < 0.5;
                             final double adjustedLightness = (isDark
                                     ? hslColor.lightness +
                                         lightnessChangeAmount
                                     : hslColor.lightness -
                                         lightnessChangeAmount)
                                 .clamp(0.0, 1.0);

                             final Color lighterColor =
                                 hslColor
                                     .withLightness(adjustedLightness)
                                     .toColor();

                             return Icon(
                               Icons.arrow_drop_up_rounded,
                               size: 60,
                               color: lighterColor,
                             );
                           },
                         ),
                       ),
                     ),
                   ),
                 ),
               ),
           ],
         ),
       );
}

class _SegmentEndpointMarkerPainter extends CustomPainter {
  const _SegmentEndpointMarkerPainter({
    required this.color,
    required this.type,
  });

  final Color color;
  final _SegmentEndpointMarkerType type;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint colorPaint = Paint()..color = color;
    final Paint haloPaint = Paint()..color = color.withValues(alpha: .22);
    final Paint lightPaint =
        Paint()..color = Colors.white.withValues(alpha: .92);
    final Paint shadowPaint =
        Paint()..color = Colors.black.withValues(alpha: .18);

    switch (type) {
      case _SegmentEndpointMarkerType.start:
        _paintStartMarker(
          canvas: canvas,
          size: size,
          colorPaint: colorPaint,
          haloPaint: haloPaint,
          lightPaint: lightPaint,
          shadowPaint: shadowPaint,
        );
      case _SegmentEndpointMarkerType.end:
        _paintEndMarker(
          canvas: canvas,
          size: size,
          colorPaint: colorPaint,
          haloPaint: haloPaint,
          lightPaint: lightPaint,
          shadowPaint: shadowPaint,
        );
    }
  }

  void _paintStartMarker({
    required Canvas canvas,
    required Size size,
    required Paint colorPaint,
    required Paint haloPaint,
    required Paint lightPaint,
    required Paint shadowPaint,
  }) {
    canvas.drawCircle(
      Offset(size.width * .36, size.height * .72),
      size.width * .26,
      haloPaint,
    );
    canvas.drawCircle(
      Offset(size.width * .36, size.height * .72),
      size.width * .11,
      shadowPaint,
    );

    final RRect pole = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * .31,
        size.height * .14,
        size.width * .1,
        size.height * .58,
      ),
      Radius.circular(size.width * .05),
    );

    canvas.drawRRect(pole, colorPaint);

    final ui.Path pennant =
        ui.Path()
          ..moveTo(size.width * .4, size.height * .15)
          ..lineTo(size.width * .84, size.height * .27)
          ..lineTo(size.width * .4, size.height * .42)
          ..close();

    canvas.drawShadow(pennant, Colors.black.withValues(alpha: .25), 2, true);
    canvas.drawPath(pennant, colorPaint);

    final ui.Path crease =
        ui.Path()
          ..moveTo(size.width * .52, size.height * .19)
          ..lineTo(size.width * .52, size.height * .38)
          ..lineTo(size.width * .4, size.height * .42)
          ..lineTo(size.width * .4, size.height * .15)
          ..close();

    canvas.drawPath(crease, lightPaint);
  }

  void _paintEndMarker({
    required Canvas canvas,
    required Size size,
    required Paint colorPaint,
    required Paint haloPaint,
    required Paint lightPaint,
    required Paint shadowPaint,
  }) {
    canvas.drawCircle(
      Offset(size.width * .36, size.height * .72),
      size.width * .26,
      haloPaint,
    );
    canvas.drawCircle(
      Offset(size.width * .36, size.height * .72),
      size.width * .11,
      shadowPaint,
    );

    final RRect pole = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * .3,
        size.height * .12,
        size.width * .1,
        size.height * .6,
      ),
      Radius.circular(size.width * .05),
    );
    canvas.drawRRect(pole, colorPaint);

    final Rect flag = Rect.fromLTWH(
      size.width * .4,
      size.height * .14,
      size.width * .42,
      size.height * .34,
    );
    final RRect flagShape = RRect.fromRectAndRadius(
      flag,
      Radius.circular(size.width * .04),
    );
    canvas.drawShadow(
      ui.Path()..addRRect(flagShape),
      Colors.black.withValues(alpha: .22),
      2,
      true,
    );
    canvas.drawRRect(flagShape, lightPaint);

    final double cellWidth = flag.width / 2;
    final double cellHeight = flag.height / 2;
    canvas.drawRect(
      Rect.fromLTWH(flag.left, flag.top, cellWidth, cellHeight),
      colorPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        flag.left + cellWidth,
        flag.top + cellHeight,
        cellWidth,
        cellHeight,
      ),
      colorPaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * .24,
          size.height * .69,
          size.width * .24,
          size.height * .1,
        ),
        Radius.circular(size.width * .05),
      ),
      colorPaint,
    );
  }

  @override
  bool shouldRepaint(_SegmentEndpointMarkerPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.type != type;
  }
}
