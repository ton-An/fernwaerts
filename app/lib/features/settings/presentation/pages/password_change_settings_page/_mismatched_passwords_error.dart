part of 'password_change_settings_page.dart';

class _MismatchedPasswordsError extends StatelessWidget {
  const _MismatchedPasswordsError({required this.display});

  final bool display;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return AnimatedSize(
      duration: theme.durations.medium,
      curve: Curves.easeOut,
      child: SizedBox(
        height: display ? null : 0,
        child: AnimatedOpacity(
          duration: Duration.zero,
          opacity: display ? 1 : 0,
          child: Text(
            AppLocalizations.of(context)!.newPasswordsDoNotMatch,
            style: theme.text.subhead.copyWith(color: theme.colors.hint),
          ),
        ),
      ),
    );
  }
}
