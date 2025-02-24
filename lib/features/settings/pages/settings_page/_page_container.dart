part of 'settings_page.dart';

class _PageContainer extends StatelessWidget {
  const _PageContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final LocationHistoryThemeData theme = LocationHistoryTheme.of(context);

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
