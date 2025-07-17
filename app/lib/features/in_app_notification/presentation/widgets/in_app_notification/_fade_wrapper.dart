part of 'in_app_notification.dart';

class _FadeWrapper extends StatefulWidget {
  const _FadeWrapper({required this.child});

  final Widget child;

  @override
  State<_FadeWrapper> createState() => _FadeWrapperState();
}

/// A state class that represents fadewrapper state.
class _FadeWrapperState extends State<_FadeWrapper>
    with SingleTickerProviderStateMixin {
  late Animation _fadeOutAnimation;
  late AnimationController _fadeOutController;

  bool _didInitAnimations = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    if (!_didInitAnimations) {
      _fadeOutController =
          AnimationController(duration: theme.durations.short, vsync: this)
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
        Tween<double>(
          begin: 1,
          end: 0,
        ).chain(CurveTween(curve: Curves.easeOut)),
      );

      _didInitAnimations = true;
    } else {
      _fadeOutController.duration = theme.durations.short;
    }
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
