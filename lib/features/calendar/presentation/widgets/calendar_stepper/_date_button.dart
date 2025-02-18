part of 'calendar_stepper.dart';

class _DateButton extends StatefulWidget {
  const _DateButton();

  @override
  State<_DateButton> createState() => _DateButtonState();
}

class _DateButtonState extends State<_DateButton>
    with SingleTickerProviderStateMixin {
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
    ).drive(IntTween(begin: 0, end: 18));

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

    return BlocBuilder<CalendarExpansionCubit, CalendarExpansionState>(
      builder: (context, state) {
        return GestureDetector(
          onTapDown: (_) {
            _fadeController.forward();
          },
          onTapUp: (_) {
            _fadeController.forward().then((_) {
              _fadeController.reverse();
            });

            context.read<CalendarExpansionCubit>().toggleExpansion();
          },
          onTapCancel: () {
            _fadeController.forward().then((_) {
              _fadeController.reverse();
            });
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(theme.radii.medium),
            child: Container(
              height: CalendarStepper.height,
              color: theme.colors.background,
              child: ColoredBox(
                color: theme.colors.text.withAlpha(_fadeAnimation.value),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '12 Dec 2024',
                      style: theme.text.title3.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: theme.spacing.xSmall),
                    AnimatedRotation(
                      duration: Duration(milliseconds: 200),
                      turns: state is CalendarCollapsed ? 0 : .5,
                      child: Icon(
                        CupertinoIcons.arrow_down_circle_fill,
                        color: Color(0xFFFFC107),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
