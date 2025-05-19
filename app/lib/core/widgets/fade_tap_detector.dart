import 'package:flutter/material.dart';

class FadeTapDetector extends StatefulWidget {
  const FadeTapDetector({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
  });

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget child;

  @override
  State<FadeTapDetector> createState() => _FadeTapDetectorState();
}

class _FadeTapDetectorState extends State<FadeTapDetector>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 1, end: .8)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_fadeAnimationController);
  }

  @override
  void dispose() {
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: widget.onLongPress,
      onTapDown: (_) {
        _fadeAnimationController.forward();
      },
      onTapUp: (_) async {
        if (widget.onTap != null) widget.onTap!();

        if (_fadeAnimationController.isCompleted) {
          _fadeAnimationController.reverse();
        } else {
          await _fadeAnimationController.forward();
          _fadeAnimationController.reverse();
        }
      },
      onTapCancel: () {
        _fadeAnimationController.reverse();
      },
      child: FadeTransition(opacity: _fadeAnimation, child: widget.child),
    );
  }
}
