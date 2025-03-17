part of 'location_history_modal.dart';

class _PlaceListItem extends StatelessWidget {
  const _PlaceListItem({required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    final String timeFrame = TimeDateFormatter.getTimeFrame(
      place.startTime,
      place.endTime,
      Localizations.localeOf(context).languageCode,
    );

    final WebfabrikThemeData theme = WebfabrikTheme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _PlaceIcon(type: place.type),
        XXSmallGap(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(place.name, style: theme.text.headline),
              XTinyGap(),
              Text(timeFrame, style: theme.text.body),
            ],
          ),
        ),
      ],
    );
  }
}
