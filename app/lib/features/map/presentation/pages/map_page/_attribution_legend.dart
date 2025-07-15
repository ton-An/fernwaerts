part of 'map_page.dart';

/// {@template attribution_legend}
/// A class that represents attribution legend.
/// {@endtemplate}
class _AttributionLegend extends StatelessWidget {
/// {@macro attribution_legend}
  const _AttributionLegend();

  static const String attributionUrl =
      'https://www.openstreetmap.org/copyright';

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return FadeTapDetector(
      onTap: () {
        launchUrlString(attributionUrl);
      },
      child: _LegendContainer(
        child: Text(
          AppLocalizations.of(context)!.openStreetMapAttribution,
          style: theme.text.subhead.copyWith(
            height: 1,
            color: theme.colors.text.withValues(alpha: .7),
          ),
        ),
      ),
    );
  }
}
