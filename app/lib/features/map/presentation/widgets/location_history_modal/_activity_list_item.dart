part of 'location_history_modal.dart';

extension ActivityTypeLocalizationExtension on ActivityType {
  String localize(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    switch (this) {
      case ActivityType.running:
        return localizations.activityTypeRunning;
      case ActivityType.cycling:
        return localizations.activityTypeCycling;
      case ActivityType.walking:
        return localizations.activityTypeWalking;
      case ActivityType.driving:
        return localizations.activityTypeDriving;
    }
  }
}

// ignore: unused_element
class _ActivityListItem extends StatelessWidget {
  const _ActivityListItem({required this.activity});

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);
    final String distance = NumberFormatter.formatDistance(
      activity.distance,
      Localizations.localeOf(context).languageCode,
    );
    final String duration = TimeDateFormatter.getDuration(
      activity.startTime,
      activity.endTime,
    );
    final String timeFrame = TimeDateFormatter.getTimeFrame(
      activity.startTime,
      activity.endTime,
      Localizations.localeOf(context).languageCode,
    );

    return Row(
      children: [
        SizedBox(width: theme.spacing.xMedium - theme.spacing.tiny),
        const _DottedHistoryLine(),
        const XLargeGap(),
        const _VerticalListItemDivider(),
        Expanded(
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: theme.spacing.medium + theme.spacing.small,
                ),
                child: _ActivityIcon(type: activity.type),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(distance, style: theme.text.body),
                      const XSmallGap(),
                      const Dot(),
                      const XSmallGap(),
                      Text(
                        duration,
                        style: theme.text.body.copyWith(
                          color: theme.colors.hint,
                        ),
                      ),
                    ],
                  ),
                  const TinyGap(),
                  Text(timeFrame, style: theme.text.body),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
