import 'package:flutter/cupertino.dart';
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
        bottom: MediaQuery.of(context).viewPadding.bottom +
            MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showBackButton) ...[
            Align(
              alignment: Alignment.topLeft,
              child: SmallIconButton(
                icon: CupertinoIcons.back,
                alignmentOffset: Offset(-1, 0),
                onPressed: onBackPressed ?? () {},
              ),
            ),
            XTinyGap(),
          ],
          Icon(
            icon,
            color: theme.colors.primary.withValues(alpha: .6),
            size: 82,
          ),
          AnimatedOpacity(
            opacity: MediaQuery.of(context).viewInsets.bottom == 0 ? 1 : 0,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: SizedBox(
                height:
                    MediaQuery.of(context).viewInsets.bottom == 0 ? null : 0,
                child: Column(
                  children: [
                    MediumGap(),
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: theme.text.largeTitle.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SmallGap(),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: theme.text.body.copyWith(
                        height: 1.45,
                      ),
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
          XMediumGap(),
          for (final textField in textFields) ...[
            textField,
            if (textFields.last != textField) MediumGap(),
          ],
          XXMediumGap(),
          CustomCupertinoTextButton(
            text: buttonText,
            onPressed: onButtonPressed,
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom == 0
                  ? theme.spacing.medium
                  : 0,
            ),
          ),
        ],
      ),
    );
  }
}
