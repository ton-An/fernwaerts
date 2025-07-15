part of 'map_page.dart';

/// {@template time_gradient_legend}
/// A class that represents time gradient legend.
/// {@endtemplate}
class _TimeGradientLegend extends StatelessWidget {
/// {@macro time_gradient_legend}
  const _TimeGradientLegend();

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return _LegendContainer(
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
