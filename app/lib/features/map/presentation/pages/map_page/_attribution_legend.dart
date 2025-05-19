part of 'map_page.dart';

class _AttributionLegend extends StatelessWidget {
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
