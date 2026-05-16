import 'package:flutter/material.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

/// {@template settings_slide_transition_page}
/// Page wrapper that gives settings subpages the shared slide transition.
/// {@endtemplate}
class SettingsSlideTransitionPage<T> extends Page<T> {
  /// {@macro settings_slide_transition_page}
  const SettingsSlideTransitionPage({
    required this.child,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  /// Settings page content to display inside the route.
  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);
    final Duration transitionDuration = theme.durations.medium;
    final Duration reverseTransitionDuration = theme.durations.medium;

    return _SettingsTransitionPageRoute<T>(
      page: this,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
    );
  }
}

/// {@template settings_transition_page_route}
/// Transparent page route that slides settings pages in and out horizontally.
/// {@endtemplate}
class _SettingsTransitionPageRoute<T> extends PageRoute<T> {
  /// {@macro settings_transition_page_route}
  _SettingsTransitionPageRoute({
    required SettingsSlideTransitionPage<T> page,
    required this.transitionDuration,
    required this.reverseTransitionDuration,
  }) : super(settings: page);

  SettingsSlideTransitionPage<T> get _page =>
      settings as SettingsSlideTransitionPage<T>;

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
    bool isAnimatingPrimary = animation.isAnimating;

    final end = isAnimatingPrimary ? Offset.zero : const Offset(-1, 0);
    final begin = isAnimatingPrimary ? const Offset(1, 0) : Offset.zero;
    final tween = Tween(
      begin: begin,
      end: end,
    ).chain(CurveTween(curve: Curves.easeInOut));
    final offsetAnimation =
        (isAnimatingPrimary ? animation : secondaryAnimation).drive(tween);

    return SlideTransition(position: offsetAnimation, child: child);
  }
}
