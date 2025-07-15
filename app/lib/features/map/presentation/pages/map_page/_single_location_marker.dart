part of 'map_page.dart';

/// {@template single_location_marker}
/// A class that represents single location marker.
/// {@endtemplate}
class _SingleLocationMarker extends Marker {
/// {@macro single_location_marker}
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
                         child: Icon(
                           Icons.arrow_drop_up_rounded,
                           size: 60,
                           color: color,
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
