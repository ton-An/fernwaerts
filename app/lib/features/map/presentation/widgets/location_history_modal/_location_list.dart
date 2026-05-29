part of 'location_history_modal.dart';

/// {@template location_list}
/// Renders the modal body from the current [MapCubit] state.
/// {@endtemplate}
class _LocationList extends StatelessWidget {
  /// {@macro location_list}
  const _LocationList({required this.scrollController});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);
    return EdgeFade(
      bottomOptions: const EdgeFadeOptions(enabled: false),
      child: BlocBuilder<MapCubit, MapState>(
        builder: (BuildContext context, MapState state) {
          if (state is MapLocationsLoaded) {
            if (state.activitySegments.isEmpty) {
              return _EmptyList(
                scrollController: scrollController,
                message: 'No activity segments',
              );
            }

            final Map<String, Location> locationsById = {
              for (final Location location in state.locations)
                location.id: location,
            };

            return ListView.builder(
              padding: EdgeInsets.all(theme.spacing.xMedium),
              shrinkWrap: true,
              itemCount: state.activitySegments.length * 2 + 1,
              controller: scrollController,
              itemBuilder: (context, index) {
                final bool isLocationRow = index.isEven;

                if (isLocationRow) {
                  final int segmentIndex = index ~/ 2;
                  final String? locationId = _locationIdForTimelinePlace(
                    activitySegments: state.activitySegments,
                    segmentIndex: segmentIndex,
                  );
                  final Location? location = locationsById[locationId];

                  if (location == null) {
                    return const SizedBox.shrink();
                  }

                  return _LocationListItem(
                    location: location,
                    onTap: () {
                      context.read<MapAnimationCubit>().animateToLocation(
                        location,
                      );
                    },
                  );
                }

                final int segmentIndex = index ~/ 2;

                return _ActivitySegmentListItem(
                  activitySegment: state.activitySegments[segmentIndex],
                  locationsById: locationsById,
                );
              },
            );
          }

          return ListView(
            padding: EdgeInsets.all(theme.spacing.xMedium),
            shrinkWrap: true,
            controller: scrollController,
            children: const [],
          );
        },
      ),
    );
  }

  String? _locationIdForTimelinePlace({
    required List<ActivitySegment> activitySegments,
    required int segmentIndex,
  }) {
    if (segmentIndex == 0) {
      return activitySegments.first.startLocationId;
    }

    return activitySegments[segmentIndex - 1].endLocationId;
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList({required this.scrollController, required this.message});

  final ScrollController scrollController;
  final String message;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);
    return ListView(
      padding: EdgeInsets.all(theme.spacing.xMedium),
      shrinkWrap: true,
      controller: scrollController,
      children: [
        Center(
          child: Text(
            message,
            style: theme.text.title3.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colors.text.withValues(alpha: .4),
            ),
          ),
        ),
      ],
    );
  }
}
