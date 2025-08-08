part of 'location_history_modal.dart';

class _LocationList extends StatelessWidget {
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
            if (state.locations.isEmpty) {
              return ListView(
                padding: EdgeInsets.all(theme.spacing.xMedium),
                shrinkWrap: true,
                controller: scrollController,
                children: [
                  Center(
                    child: Text(
                      'No Data :)',
                      style: theme.text.title3.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colors.text.withValues(alpha: .4),
                      ),
                    ),
                  ),
                ],
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(theme.spacing.xMedium),
              shrinkWrap: true,
              itemCount: state.locations.length,
              controller: scrollController,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    _LocationListItem(location: state.locations[index]),
                    if (index != state.locations.length - 1)
                      Container(
                        margin: EdgeInsets.only(
                          left: theme.spacing.xMedium - theme.spacing.tiny,
                        ),
                        alignment: Alignment.centerLeft,
                        child: const _DottedHistoryLine(),
                      ),
                  ],
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
}
