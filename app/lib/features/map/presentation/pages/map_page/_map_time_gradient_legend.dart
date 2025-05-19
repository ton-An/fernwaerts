part of 'map_page.dart';

class _MapTimeGradientLegend extends StatelessWidget {
  const _MapTimeGradientLegend();

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return _MapLegendContainer(
      child: Container(
        height: 10,
        margin: EdgeInsets.all(theme.spacing.xTiny),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.3),
          gradient: LinearGradient(colors: theme.colors.timelineGradient),
        ),
      ),
    );
  }
}
