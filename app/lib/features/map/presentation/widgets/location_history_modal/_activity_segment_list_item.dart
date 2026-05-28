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
    final Location? startLocation =
        locationsById[activitySegment.startLocationId];
    final Location? endLocation = locationsById[activitySegment.endLocationId];

    if (startLocation == null || endLocation == null) {
      return const SizedBox.shrink();
    }

    final String languageCode = Localizations.localeOf(context).languageCode;
    final String distance = NumberFormatter.formatDistance(
      _calculateDistanceInKilometers(
        startLocation: startLocation,
        endLocation: endLocation,
      ),
      languageCode,
    );
    final String duration = TimeDateFormatter.getDuration(
      startLocation.timestamp,
      endLocation.timestamp,
    );

    return Column(
      children: [
        _LocationListItem(
          location: startLocation,
          onTap: () {
            context.read<MapAnimationCubit>().animateToLocation(startLocation);
          },
        ),
        _ActivitySegmentConnector(distance: distance, duration: duration),
        _LocationListItem(
          location: endLocation,
          onTap: () {
            context.read<MapAnimationCubit>().animateToLocation(endLocation);
          },
        ),
      ],
    );
  }

  double _calculateDistanceInKilometers({
    required Location startLocation,
    required Location endLocation,
  }) {
    const Distance distanceUtils = Distance();

    return distanceUtils.as(
      LengthUnit.Kilometer,
      LatLng(startLocation.latitude, startLocation.longitude),
      LatLng(endLocation.latitude, endLocation.longitude),
    );
  }
}

class _ActivitySegmentConnector extends StatelessWidget {
  const _ActivitySegmentConnector({
    required this.distance,
    required this.duration,
  });

  final String distance;
  final String duration;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);
    return Row(
      children: [
        SizedBox(width: theme.spacing.xMedium - theme.spacing.tiny),
        const _DottedHistoryLine(),
        const XLargeGap(),
        Expanded(
          child: Row(
            children: [
              Row(
                children: [
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
            ],
          ),
        ),
      ],
    );
  }
}
