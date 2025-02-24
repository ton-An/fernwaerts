import 'package:flutter/widgets.dart';
import 'package:location_history/core/theme/location_history_theme.dart';

class SmallIconButton extends StatefulWidget {
  const SmallIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.alignmentOffset = Offset.zero,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Offset alignmentOffset;

  @override
  State<SmallIconButton> createState() => _SmallIconButtonState();
}

class _SmallIconButtonState extends State<SmallIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 215),
      reverseDuration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    ).drive(
      Tween<double>(begin: 1, end: .4),
    );

    _fadeController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LocationHistoryThemeData theme = LocationHistoryTheme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (_) {
        _fadeController.forward();
      },
      onTapCancel: () {
        _fadeController.forward().then((_) {
          _fadeController.reverse();
        });
      },
      onTapUp: (_) {
        _fadeController.forward().then((_) {
          _fadeController.reverse();
        });
        widget.onPressed();
      },
      child: Opacity(
        opacity: _fadeAnimation.value,
        child: Container(
          padding: EdgeInsets.all(theme.spacing.xSmall),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colors.translucentBackgroundContrast,
          ),
          child: Transform.translate(
            offset: widget.alignmentOffset,
            child: Icon(
              widget.icon,
              color: theme.colors.text,
            ),
          ),
        ),
      ),
    );
  }
}
