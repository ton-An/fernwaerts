part of 'calendar_stepper.dart';

class _Switch extends StatefulWidget {
  const _Switch({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  State<_Switch> createState() => _SwitchState();
}

class _SwitchState extends State<_Switch> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<int> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 160),
      reverseDuration: const Duration(milliseconds: 220),
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
  }

  @override
  Widget build(BuildContext context) {
    final LocationHistoryThemeData theme = LocationHistoryTheme.of(context);

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
        size: Size(CalendarStepper.height, CalendarStepper.height),
        child: Container(
          width: CalendarStepper.height + 30,
          height: CalendarStepper.height,
          decoration: BoxDecoration(
            color: theme.colors.text.withAlpha(_fadeAnimation.value),
            borderRadius: BorderRadius.horizontal(
                left: Radius.circular(
              theme.radii.medium,
            )),
          ),
          child: Icon(
            widget.icon,
            color: theme.colors.text,
          ),
        ),
      ),
    );
  }
}
