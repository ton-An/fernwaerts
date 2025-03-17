part of 'location_history_modal.dart';

class _LocationList extends StatelessWidget {
  const _LocationList({required this.scrollController});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);
    return EdgeFade(
      bottomOptions: EdgeFadeOptions(enabled: false),
      child: ListView.builder(
        padding: EdgeInsets.all(theme.spacing.xMedium),
        shrinkWrap: true,
        itemCount: mockLocationHistoryItems.length,
        controller: scrollController,
        itemBuilder: (context, index) {
          if (mockLocationHistoryItems[index] is Activity) {
            return _ActivityListItem(
              activity: mockLocationHistoryItems[index] as Activity,
            );
          } else if (mockLocationHistoryItems[index] is Place) {
            return _PlaceListItem(
              place: mockLocationHistoryItems[index] as Place,
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
