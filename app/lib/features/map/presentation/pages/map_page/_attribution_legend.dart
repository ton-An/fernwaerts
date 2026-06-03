part of 'map_page.dart';

/// {@template attribution_legend}
/// Opens the OpenStreetMap attribution page from the map legend.
/// {@endtemplate}
class _AttributionLegend extends StatelessWidget {
  /// {@macro attribution_legend}
  const _AttributionLegend();

  static const String attributionUrl =
      'https://www.openstreetmap.org/copyright';

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return Semantics(
      label: AppLocalizations.of(context)!.semanticOpenStreetMapAttributionLink,
      button: true,
      child: FadeTapDetector(
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
      ),
    );
  }
}
