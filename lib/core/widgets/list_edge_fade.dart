import 'package:flutter/material.dart';

class ListEdgeFade extends StatelessWidget {
  const ListEdgeFade({
    super.key,
    required this.child,
    this.top = true,
    this.bottom = true,
    this.fadeHeightFactor = 0.1,
  });

  final Widget child;
  final bool top;
  final bool bottom;
  final double fadeHeightFactor;

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = [];
    final List<double> stops = [];

    if (top) {
      colors.add(Colors.transparent);
      stops.add(0.0);
      colors.add(Colors.black);
      stops.add(fadeHeightFactor);
    }

    if (bottom) {
      colors.add(Colors.black);
      stops.add(1 - fadeHeightFactor);
      colors.add(Colors.transparent);
      stops.add(1.0);
    }

    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
          stops: stops, // Adjust stops for fade range
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: child,
    );
  }
}
