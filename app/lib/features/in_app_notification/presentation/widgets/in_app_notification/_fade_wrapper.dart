part of 'in_app_notification.dart';

class _FadeWrapper extends StatefulWidget {
  const _FadeWrapper({required this.child});

  final Widget child;

  @override
  State<_FadeWrapper> createState() => _FadeWrapperState();
}

class _FadeWrapperState extends State<_FadeWrapper>
    with SingleTickerProviderStateMixin {
  late Animation _fadeOutAnimation;
  late AnimationController _fadeOutController;

  @override
  void initState() {
    super.initState();

    _fadeOutController =
        AnimationController(
            duration: const Duration(milliseconds: 220),
            vsync: this,
          )
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              context
                  .read<InAppNotificationCubit>()
                  .confirmNotificationReplaced();
            }
          });

    _fadeOutAnimation = _fadeOutController.drive(
      Tween<double>(begin: 1, end: 0).chain(CurveTween(curve: Curves.easeOut)),
    );
  }

  @override
  void dispose() {
    _fadeOutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InAppNotificationCubit, InAppNotificationState>(
      listener: (context, state) {
        if (state is InAppNotificationReplacing) {
          _fadeOutController.forward();
        }
      },
      child: Opacity(opacity: _fadeOutAnimation.value, child: widget.child),
    );
  }
}
