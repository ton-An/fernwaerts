part of 'in_app_notification_widget.dart';

class _Decoration extends StatelessWidget {
  const _Decoration({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(theme.radii.medium),
      child: BackdropFilter(
        filter: theme.misc.blurFilter,
        child: Container(
          decoration: BoxDecoration(
            color: theme.colors.background.withValues(alpha: .6),
            borderRadius: BorderRadius.circular(theme.radii.medium),
          ),
          child: child,
        ),
      ),
    );
  }
}
