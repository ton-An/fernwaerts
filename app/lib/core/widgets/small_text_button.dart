import 'package:flutter/material.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

class SmallTextButton extends StatefulWidget {
  const SmallTextButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  State<SmallTextButton> createState() => _SmallTextButtonState();
}

class _SmallTextButtonState extends State<SmallTextButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  bool _didInitAnimation = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    if (!_didInitAnimation) {
      _fadeController = AnimationController(
        duration: theme.durations.xxTiny,
        reverseDuration: theme.durations.short,
        vsync: this,
      );

      _fadeController.addListener(() {
        setState(() {});
      });

      _fadeAnimation = Tween<double>(begin: 0, end: .08).animate(
        CurvedAnimation(
          parent: _fadeController,
          curve: Curves.easeOut,
          reverseCurve: Curves.easeIn,
        ),
      );

      _didInitAnimation = true;
    } else {
      _fadeController.duration = theme.durations.xxTiny;
      _fadeController.reverseDuration = theme.durations.short;
    }
  }

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return GestureDetector(
      onTapDown: (_) {
        _fadeController.forward();
      },
      onTapUp: (_) {
        _fadeController.forward().then((_) {
          _fadeController.reverse();
        });
        widget.onPressed();
      },
      onTapCancel: () {
        _fadeController.forward().then((_) {
          _fadeController.reverse();
        });
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsetsGeometry.symmetric(
              horizontal: theme.spacing.xMedium,
              vertical: theme.spacing.xxSmall,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(theme.radii.small),
              color: theme.colors.backgroundContrast.withValues(
                alpha: _fadeAnimation.value,
              ),
            ),
            child: Text(
              widget.text,
              textAlign: TextAlign.center,
              style: theme.text.body.copyWith(color: theme.colors.hint),
            ),
          ),
        ],
      ),
    );
  }
}
