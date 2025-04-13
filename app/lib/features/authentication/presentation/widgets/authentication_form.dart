import 'package:flutter/cupertino.dart';
import 'package:super_keyboard/super_keyboard.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

class AuthenticationForm extends StatelessWidget {
  const AuthenticationForm({
    super.key,
    required this.icon,
    required this.label,
    required this.description,
    required this.buttonText,
    required this.textFields,
    required this.onButtonPressed,
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
              if (showBackButton) ...[
                Align(
                  alignment: Alignment.topLeft,
                  child: SmallIconButton(
                    icon: CupertinoIcons.back,
                    alignmentOffset: const Offset(-1, 0),
                    onPressed: onBackPressed ?? () {},
                  ),
                ),
                const XTinyGap(),
              ],
              Icon(
                icon,
                color: theme.colors.primary.withValues(alpha: .6),
                size: 82,
              ),
              AnimatedOpacity(
                opacity: isKeyboardVisible ? 0 : 1,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  child: SizedBox(
                    height: isKeyboardVisible ? 0 : null,
                    child: Column(
                      children: [
                        const MediumGap(),
                        Text(
                          label,
                          textAlign: TextAlign.center,
                          style: theme.text.largeTitle.copyWith(
                            fontWeight: FontWeight.w600,
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
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
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
