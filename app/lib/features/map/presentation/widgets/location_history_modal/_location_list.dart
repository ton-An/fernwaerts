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
          if (state is! MapLocationsLoaded || state.activitySegments.isEmpty) {
            return _EmptyList(scrollController: scrollController);
          }

          return ListView(
            padding: EdgeInsets.all(theme.spacing.xMedium),
            shrinkWrap: true,
            controller: scrollController,
            children: _timelineRows(context, state),
          );
        },
      ),
    );
  }

  /// Builds the alternating place / activity-segment rows for the timeline.
  List<Widget> _timelineRows(BuildContext context, MapLocationsLoaded state) {
    final Map<String, Location> locationsById = {
      for (final Location location in state.locations) location.id: location,
    };
    final List<String> boundaryLocationIds =
        state.activitySegments.boundaryLocationIds;

    final List<Widget> rows = [];
    for (int i = 0; i < boundaryLocationIds.length; i++) {
      final Location? location = locationsById[boundaryLocationIds[i]];
      if (location != null) {
        rows.add(
          _LocationListItem(
            location: location,
            onTap:
                () => context.read<MapAnimationCubit>().animateToLocation(
                  location,
                ),
          ),
        );
      }

      if (i < state.activitySegments.length) {
        rows.add(
          _ActivitySegmentListItem(
            activitySegment: state.activitySegments[i],
            locationsById: locationsById,
          ),
        );
      }
    }

    return rows;
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList({required this.scrollController});

  final ScrollController scrollController;

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
            AppLocalizations.of(context)!.noData,
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
