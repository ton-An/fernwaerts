part of 'settings_page.dart';

/// {@template section_title}
/// A class that represents section title.
/// {@endtemplate}
class _SectionTitle extends StatelessWidget {
/// {@macro section_title}
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: theme.spacing.large,
        bottom: theme.spacing.small,
      ),
      child: Text(
        title,
        style: theme.text.title1.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
