part of 'authentication_form.dart';

/// A widget that shows the label, description, and optional hint for the AuthenticationForm.
///
/// Animates opacity and size based on keyboard visibility.
///
/// Parameters:
/// - label: The title text of the form.
/// - description: The descriptive text of the form.
/// - hint: Optional hint text to show below the description.
/// - isKeyboardVisible: Controls hiding the description when keyboard is open.
class _Description extends StatelessWidget {
  const _Description({
    required this.label,
    required this.description,
    required this.hint,
    required this.isKeyboardVisible,
  });

  final String label;
  final String description;
  final String? hint;
  final bool isKeyboardVisible;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return AnimatedOpacity(
      opacity: isKeyboardVisible ? 0 : 1,
      duration: theme.durations.xxMedium,
      curve: Curves.easeInOut,
      child: AnimatedSize(
        duration: theme.durations.medium,
        curve: Curves.easeOut,
        child: SizedBox(
          height: isKeyboardVisible ? 0 : null,
          child: Column(
            children: [
              const MediumGap(),
              GestureDetector(
                onDoubleTap: () {
                  context.push(DebugPage.route);
                },
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: theme.text.largeTitle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SmallGap(),
              Text(
                description,
                textAlign: TextAlign.center,
                style: theme.text.body.copyWith(height: 1.45),
              ),
              if (hint != null)
                Text(
                  hint!,
                  textAlign: TextAlign.center,
                  style: theme.text.body.copyWith(
                    height: 1.45,
                    color: theme.colors.text.withValues(alpha: .5),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
