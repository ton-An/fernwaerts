part of 'settings_page.dart';

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final LocationHistoryThemeData theme = LocationHistoryTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: theme.spacing.large,
        bottom: theme.spacing.small,
      ),
      child: Text(
        title,
        style: theme.text.title1.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
