part of 'map_page.dart';

/// {@template place_marker}
/// A circular timeline marker for an inferred location or place point.
/// {@endtemplate}
class _PlaceMarker extends Marker {
  /// {@macro place_marker}
  _PlaceMarker({required super.point, required Color color})
    : super(
        width: _markerSize,
        height: _markerSize,
        child: Center(
          child: Container(
            width: _dotSize,
            height: _dotSize,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: _haloOpacity),
                  blurRadius: 0,
                  spreadRadius: _haloSpread,
                ),
              ],
            ),
            child: Icon(
              Icons.place,
              size: _iconSize,
              color: Colors.white.withValues(alpha: _iconOpacity),
            ),
          ),
        ),
      );

  static const double _markerSize = 38;
  static const double _dotSize = 30;
  static const double _iconSize = 19;
  static const double _haloSpread = 6;
  static const double _haloOpacity = .22;
  static const double _iconOpacity = .92;
}
