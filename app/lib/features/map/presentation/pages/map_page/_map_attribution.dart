part of 'map_page.dart';

class _MapAttribution extends StatelessWidget {
  const _MapAttribution();

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return GestureDetector(
      onTap: () {
        launchUrlString('https://www.openstreetmap.org/copyright');
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
