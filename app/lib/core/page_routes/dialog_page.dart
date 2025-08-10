import 'package:flutter/material.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

class DialogPage<T> extends Page<T> {
  const DialogPage({
    required this.child,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);
    final Duration transitionDuration = theme.durations.short;
    final Duration reverseTransitionDuration = theme.durations.short;

    return _DialogPageRoute<T>(
      page: this,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
    );
  }
}

class _DialogPageRoute<T> extends PageRoute<T> {
  _DialogPageRoute({
    required DialogPage<T> page,
    required this.transitionDuration,
    required this.reverseTransitionDuration,
  }) : super(settings: page);

  DialogPage<T> get _page => settings as DialogPage<T>;

  @override
  Color? get barrierColor => Colors.transparent;

  @override
  String? get barrierLabel => null;

  @override
  bool get barrierDismissible => false;

  @override
  final Duration transitionDuration;
  @override
  final Duration reverseTransitionDuration;

  @override
  bool get maintainState => true;

  @override
  bool get fullscreenDialog => true;

  @override
  bool get opaque => false;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) => Semantics(
    scopesRoute: true,
    explicitChildNodes: true,
    child: _page.child,
  );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final Animation<double> curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOut,
    );

    return FadeTransition(opacity: curvedAnimation, child: child);
  }
}
