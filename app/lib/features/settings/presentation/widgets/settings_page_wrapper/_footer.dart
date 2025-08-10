part of 'settings_page_wrapper.dart';

class _Footer extends StatelessWidget {
  const _Footer({required this.title, required this.isMainPage});

  final String title;
  final bool isMainPage;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);
    return Container(
      margin: EdgeInsets.only(
        left: theme.spacing.medium,
        right: theme.spacing.medium,
        bottom: theme.spacing.medium,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.medium + theme.spacing.small,
        vertical: theme.spacing.medium + theme.spacing.small,
      ),
      decoration: BoxDecoration(
        color: theme.colors.translucentBackgroundContrast,
        borderRadius: BorderRadius.circular(theme.radii.medium),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              context.pop();
            },
            child: SmallIconButton(
              icon: isMainPage ? CupertinoIcons.clear : CupertinoIcons.back,
              onPressed: () {
                context.pop();
              },
            ),
          ),
          Text(
            title,
            style: theme.text.title1.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 28),
        ],
      ),
    );
  }
}
