part of "in_app_notification.dart";

class _Content extends StatelessWidget {
  const _Content({required this.failure});

  final Failure failure;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return Row(
      children: [
        Icon(
          CupertinoIcons.exclamationmark_triangle,
          color: theme.colors.error,
          size: 26,
        ),
        const MediumGap(),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                failure.name,
                style: theme.text.headline.copyWith(color: theme.colors.error),
                overflow: TextOverflow.ellipsis,
              ),
              const TinyGap(),
              Text(
                failure.message,
                style: theme.text.body,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
