import 'package:flutter/cupertino.dart';
import 'package:super_keyboard/super_keyboard.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

part '_back_button.dart';
part '_description.dart';

/// {@template authentication_form}
/// A form widget for authentication purposes.
///
/// This widget displays an icon, a label, a description, a list of text fields,
/// and a button. It can also optionally show a back button and a hint.
/// The form adapts its layout based on keyboard visibility.
/// {@endtemplate}
class AuthenticationForm extends StatelessWidget {
  /// {@macro authentication_form}
  const AuthenticationForm({
    super.key,
    required this.icon,
    required this.label,
    required this.description,
    required this.buttonText,
    required this.textFields,
    required this.onButtonPressed,
    required this.isLoading,
    this.showBackButton = false,
    this.onBackPressed,
    this.hint,
  });

  /// The icon to display at the top of the form.
  final IconData icon;

  /// The main label for the form.
  final String label;

  /// A more detailed description of the form's purpose.
  final String description;

  /// An optional hint displayed below the description.
  final String? hint;

  /// The text to display on the main action button.
  final String buttonText;

  /// A list of [CustomCupertinoTextField] widgets for user input.
  final List<CustomCupertinoTextField> textFields;

  /// Whether the form is currently in a loading state (e.g., submitting data).
  ///
  /// If true, the main action button will show a loading indicator.
  final bool isLoading;

  /// Callback triggered when the main action button is pressed.
  final VoidCallback onButtonPressed;

  /// Whether to display a back button at the top left of the form.
  final bool showBackButton;

  /// Callback triggered when the back button is pressed.
  ///
  /// This is only relevant if [showBackButton] is true.
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: theme.spacing.xMedium,
        right: theme.spacing.xMedium,
        top: theme.spacing.xxMedium,
        bottom:
            MediaQuery.of(context).viewPadding.bottom +
            MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SuperKeyboardBuilder(
        builder: (context, keyboardState) {
          final isKeyboardVisible =
              keyboardState == KeyboardState.open ||
              keyboardState == KeyboardState.opening;

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showBackButton) _BackButton(onPressed: onBackPressed),
              Icon(
                icon,
                color: theme.colors.primary.withValues(alpha: .6),
                size: 82,
              ),
              _Description(
                label: label,
                description: description,
                hint: hint,
                isKeyboardVisible: isKeyboardVisible,
              ),
              const XMediumGap(),
              for (final textField in textFields) ...[
                textField,
                if (textFields.last != textField) const MediumGap(),
              ],
              const XXMediumGap(),
              CustomCupertinoTextButton(
                text: buttonText,
                onPressed: onButtonPressed,
                isLoading: isLoading,
              ),
              AnimatedSize(
                duration: theme.durations.medium,
                curve: Curves.easeOut,
                child: SizedBox(
                  height: isKeyboardVisible ? 0 : theme.spacing.medium,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
