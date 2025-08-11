part of 'in_app_notification_widget.dart';

class _ContentData {
  const _ContentData({
    required this.highlightColor,
    required this.icon,
    required this.title,
    required this.message,
  });

  final Color highlightColor;
  final IconData icon;
  final String title;
  final String message;
}

class _Content extends StatelessWidget {
  const _Content({required this.notification});

  final InAppNotification notification;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    final _ContentData contentData = _getContentData(theme: theme);

    return Row(
      children: [
        Icon(contentData.icon, color: contentData.highlightColor, size: 26),
        const MediumGap(),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contentData.title,
                style: theme.text.headline.copyWith(
                  color: contentData.highlightColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const TinyGap(),
              Text(contentData.message, style: theme.text.body),
            ],
          ),
        ),
      ],
    );
  }

  _ContentData _getContentData({required WebfabrikThemeData theme}) {
    switch (notification) {
      case InAppSuccessNotification successNotification:
        return _ContentData(
          title: successNotification.title,
          message: successNotification.message,
          highlightColor: theme.colors.success,
          icon: CupertinoIcons.check_mark_circled_solid,
        );
      case InAppFailureNotification failureNotification:
        return _ContentData(
          title: failureNotification.failure.name,
          message: failureNotification.failure.message,
          highlightColor: theme.colors.error,
          icon: CupertinoIcons.exclamationmark_triangle,
        );
    }
  }
}
