part of 'password_change_settings_page.dart';

/// {@template mismatched_passwords_error}
/// Animated validation message shown when the two new password fields differ.
/// {@endtemplate}
class _MismatchedPasswordsError extends StatelessWidget {
  /// {@macro mismatched_passwords_error}
  const _MismatchedPasswordsError({required this.display});

  /// Whether the error message should be visible.
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
