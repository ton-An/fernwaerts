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
    final ActivityType activityType = _getActivityType(
      startLocation: startLocation,
      endLocation: endLocation,
    );

    return Column(
      children: [
        _LocationListItem(
          location: startLocation,
          onTap: () {
            context.read<MapAnimationCubit>().animateToLocation(startLocation);
          },
        ),
        _ActivitySegmentConnector(
          activityType: activityType,
          distance: distance,
          duration: duration,
        ),
        _LocationListItem(
          location: endLocation,
          onTap: () {
            context.read<MapAnimationCubit>().animateToLocation(endLocation);
          },
        ),
      ],
    );
  }

  ActivityType _getActivityType({
    required Location startLocation,
    required Location endLocation,
  }) {
    final List<Location> segmentLocations =
        locationsById.values
            .where(
              (Location location) =>
                  !location.timestamp.isBefore(startLocation.timestamp) &&
                  !location.timestamp.isAfter(endLocation.timestamp),
            )
            .toList()
          ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final Map<ActivityType, int> typeCounts = <ActivityType, int>{};

    for (final Location location in segmentLocations) {
      final ActivityType? displayType = _toDisplayActivityType(
        location.activityType,
      );

      if (displayType == null) {
        continue;
      }

      typeCounts.update(
        displayType,
        (int value) => value + 1,
        ifAbsent: () => 1,
      );
    }

    if (typeCounts.isEmpty) {
      return ActivityType.walking;
    }

    return typeCounts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  ActivityType? _toDisplayActivityType(tracking.ActivityType activityType) {
    switch (activityType) {
      case tracking.ActivityType.walking:
      case tracking.ActivityType.onFoot:
        return ActivityType.walking;
      case tracking.ActivityType.running:
        return ActivityType.running;
      case tracking.ActivityType.onBicycle:
        return ActivityType.cycling;
      case tracking.ActivityType.inVehicle:
        return ActivityType.driving;
      case tracking.ActivityType.still:
      case tracking.ActivityType.unknown:
        return null;
    }
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
    required this.activityType,
    required this.distance,
    required this.duration,
  });

  final ActivityType activityType;
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
              Padding(
                padding: EdgeInsets.only(right: theme.spacing.medium),
                child: _ActivityIcon(type: activityType),
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
}
