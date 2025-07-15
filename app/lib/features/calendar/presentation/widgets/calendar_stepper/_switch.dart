part of 'calendar_stepper.dart';

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
  late Animation<int> _fadeAnimation;

  bool _didInitAnimations = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    if (!_didInitAnimations) {
      _fadeController = AnimationController(
        duration: theme.durations.xxTiny,
        reverseDuration: theme.durations.short,
        vsync: this,
      );
      _fadeAnimation = CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ).drive(IntTween(begin: 0, end: 28));

      _fadeController.addListener(() {
        setState(() {});
      });

      _didInitAnimations = true;
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
      child: SizedOverflowBox(
        size: const Size(CalendarStepper.height, CalendarStepper.height),
        child: Container(
          width: CalendarStepper.height + 30,
          height: CalendarStepper.height,
          decoration: BoxDecoration(
            color: theme.colors.text.withAlpha(_fadeAnimation.value),
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(theme.radii.medium),
            ),
          ),
          child: Icon(widget.icon, color: theme.colors.text),
        ),
      ),
    );
  }
}
