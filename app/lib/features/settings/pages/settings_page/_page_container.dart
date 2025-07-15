part of 'settings_page.dart';

/// {@template page_container}
/// A container widget that wraps page content.
/// {@endtemplate}
class _PageContainer extends StatelessWidget {
/// {@macro page_container}
  const _PageContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(theme.radii.medium),
      ),
      child: BackdropFilter(
        filter: theme.misc.blurFilter,
        child: SafeArea(
          top: false,
          child: Container(
            decoration: BoxDecoration(
              color: theme.colors.translucentBackground,
              borderRadius: BorderRadius.circular(theme.radii.xLarge),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
