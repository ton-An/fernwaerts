part of 'calendar.dart';

class _Switch extends StatefulWidget {
  const _Switch({
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
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 280),
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
          child: Icon(
            widget.icon,
            color: theme.colors.text,
          ),
        ),
      ),
    );
  }
}
