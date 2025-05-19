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
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 1,
      end: .8,
    ).chain(CurveTween(curve: Curves.easeInOut)).animate(_fadeController);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: widget.onLongPress,
      onTapDown: (_) => _onTapDown(),
      onTapUp: (_) => _onTapUp(),
      onTapCancel: _onTapCancel,
      child: FadeTransition(opacity: _fadeAnimation, child: widget.child),
    );
  }

  void _onTapDown() => _fadeController.forward();

  Future<void> _onTapUp() async {
    widget.onTap?.call();
    if (_fadeController.isCompleted) {
      await _fadeController.reverse();
    } else {
      await _fadeController.forward();
      await _fadeController.reverse();
    }
  }

  void _onTapCancel() => _fadeController.reverse();
}
