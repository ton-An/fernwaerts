part of 'map_page.dart';

class _SingleLocationMarker extends Marker {
  _SingleLocationMarker({
    required super.point,
    required Offset? arrowOffset,
    required double? arrowRotation,
    required Color color,
    required bool displayArrow,
  }) : super(
         width: 24,
         height: 24,
         child: Stack(
           children: [
             Container(
               decoration: BoxDecoration(
                 shape: BoxShape.circle,
                 color: color,
                 border: Border.all(
                   width: 8,
                   color: color.withValues(alpha: .3),
                   strokeAlign: BorderSide.strokeAlignOutside,
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
