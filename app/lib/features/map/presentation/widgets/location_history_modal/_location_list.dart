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
    final List<Location> boundaryLocations =
        state.activitySegments.boundaryLocations;

    final List<Widget> rows = [];
    for (int i = 0; i < boundaryLocations.length; i++) {
      final Location location = boundaryLocations[i];
      rows.add(_LocationListItem(location: location));

      if (i < state.activitySegments.length) {
        rows.add(_ActivityListItem(activitySegment: state.activitySegments[i]));
      }
    }

    return rows;
  }
}
