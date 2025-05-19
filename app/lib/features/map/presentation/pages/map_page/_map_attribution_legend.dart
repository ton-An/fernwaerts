part of 'map_page.dart';

class _MapAttributionLegend extends StatelessWidget {
  const _MapAttributionLegend();

  static const String attributionUrl =
      'https://www.openstreetmap.org/copyright';

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return GestureDetector(
      onTap: () {
        launchUrlString(attributionUrl);
      },
      child: _MapLegendContainer(
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
