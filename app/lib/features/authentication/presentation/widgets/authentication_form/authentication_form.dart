import 'package:flutter/cupertino.dart';
import 'package:super_keyboard/super_keyboard.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

part '_back_button.dart';
part '_description.dart';

class AuthenticationForm extends StatelessWidget {
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

  final IconData icon;
  final String label;
  final String description;
  final String? hint;
  final String buttonText;
  final List<CustomCupertinoTextField> textFields;
  final bool isLoading;
  final VoidCallback onButtonPressed;
  final bool showBackButton;
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
