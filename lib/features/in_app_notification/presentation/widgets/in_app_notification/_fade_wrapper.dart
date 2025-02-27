part of in_app_notification;

class _FadeWrapper extends StatefulWidget {
  const _FadeWrapper({
    required this.child,
  });

  final Widget child;

  @override
  State<_FadeWrapper> createState() => _FadeWrapperState();
}

class _FadeWrapperState extends State<_FadeWrapper>
    with SingleTickerProviderStateMixin {
  late Animation _replacementFadeAnimation;
  late AnimationController _replacementFadeController;

  @override
  void initState() {
    super.initState();
    _initReplacementFadeAnimation();
  }

  @override
  void dispose() {
    _replacementFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InAppNotificationCubit, InAppNotificationState>(
      listener: (context, state) {
        if (state is InAppNotificationReplacing) {
          _replacementFadeController.forward();
        }
      },
      child: Opacity(
        opacity: _replacementFadeAnimation.value,
        child: widget.child,
      ),
    );
  }

  void _initReplacementFadeAnimation() {
    _replacementFadeController = AnimationController(
      duration: const Duration(milliseconds: 220),
      vsync: this,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          context.read<InAppNotificationCubit>().confirmNotificationReplaced();
        }
      });

    _replacementFadeAnimation = _replacementFadeController
        .drive(Tween<double>(begin: 1, end: 0).chain(CurveTween(
      curve: Curves.easeOut,
    )));
  }
}
