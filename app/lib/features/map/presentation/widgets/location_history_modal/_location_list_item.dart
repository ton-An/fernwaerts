part of 'location_history_modal.dart';

class _LocationListItem extends StatelessWidget {
  const _LocationListItem({required this.location});

  final Location location;

  @override
  Widget build(BuildContext context) {
    final String time = TimeDateFormatter.getTime(
      location.timestamp,
      Localizations.localeOf(context).languageCode,
    );

    final WebfabrikThemeData theme = WebfabrikTheme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const _PlaceIcon(type: PlaceType.other),
        const XXSmallGap(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Location', style: theme.text.headline),
              const XTinyGap(),
              Row(
                children: [
                  Text(time, style: theme.text.body),
                  const XSmallGap(),
                  const Dot(),
                  const XSmallGap(),
                  Text(
                    '${location.latitude.toStringAsFixed(5)}, ${location.longitude.toStringAsFixed(5)}',
                    style: theme.text.body.copyWith(color: theme.colors.hint),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
