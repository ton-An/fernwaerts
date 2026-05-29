part of 'location_history_modal.dart';

class _ActivitySegmentListItem extends StatelessWidget {
  const _ActivitySegmentListItem({
    required this.activitySegment,
    required this.locationsById,
  });

  final ActivitySegment activitySegment;
  final Map<String, Location> locationsById;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);
    final String languageCode = Localizations.localeOf(context).languageCode;

    final Location startLocation =
        locationsById[activitySegment.startLocationId]!;
    final Location endLocation = locationsById[activitySegment.endLocationId]!;

    final String distance = NumberFormatter.formatDistance(
      _distanceInKilometers(startLocation, endLocation),
      languageCode,
    );
    final String duration = TimeDateFormatter.getDuration(
      startLocation.timestamp,
      endLocation.timestamp,
    );

    return Row(
      children: [
        SizedBox(width: theme.spacing.xMedium - theme.spacing.tiny),
        const _DottedHistoryLine(),
        const XLargeGap(),
        Expanded(
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: theme.spacing.medium),
                child: _ActivityIcon(type: activitySegment.activityType),
              ),
              Text(duration, style: theme.text.body),
              const XSmallGap(),
              const Dot(),
              const XSmallGap(),
              Text(
                distance,
                style: theme.text.body.copyWith(color: theme.colors.hint),
              ),
            ],
          ),
        ),
      ],
    );
  }

  double _distanceInKilometers(Location startLocation, Location endLocation) {
    const Distance distanceUtils = Distance();

    return distanceUtils.as(
      LengthUnit.Kilometer,
      LatLng(startLocation.latitude, startLocation.longitude),
      LatLng(endLocation.latitude, endLocation.longitude),
    );
  }
}
