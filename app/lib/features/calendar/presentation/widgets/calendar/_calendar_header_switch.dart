part of 'calendar.dart';

/// {@template switch}
/// A class that represents switch.
/// {@endtemplate}
class _Switch extends StatefulWidget {
/// {@macro switch}
  const _Switch({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  State<_Switch> createState() => _SwitchState();
}

/// {@template switch_state}
/// A state class that represents switch state.
/// {@endtemplate}
class _SwitchState extends State<_Switch> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  bool _didInitAnimations = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    if (!_didInitAnimations) {
      _fadeController = AnimationController(
        duration: theme.durations.xShort,
        reverseDuration: theme.durations.xShort,
        vsync: this,
      );

      _fadeAnimation = CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ).drive(Tween(begin: 1, end: .5));

      _fadeController.addListener(() {
        setState(() {});
      });

      _didInitAnimations = true;
    } else {
      _fadeController.duration = theme.durations.xShort;
      _fadeController.reverseDuration = theme.durations.xShort;
    }
  }

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
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
      child: Opacity(
        opacity: _fadeAnimation.value,
        child: Padding(
          padding: EdgeInsets.all(theme.spacing.xMedium - theme.spacing.small),
          child: Icon(widget.icon, color: theme.colors.text),
        ),
      ),
    );
  }
}
