import 'package:flutter/cupertino.dart';
import 'package:location_history/core/theme/location_history_theme.dart';

class CustomCupertinoTextField extends StatelessWidget {
  const CustomCupertinoTextField({
    required this.hint,
    required this.onChanged,
    this.obscureText = false,
    super.key,
  });

  final String hint;
  final bool obscureText;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    final LocationHistoryThemeData theme = LocationHistoryTheme.of(context);

    return SizedBox(
      height: 44,
      child: CupertinoTextField(
        placeholder: hint,
        obscureText: obscureText,
        style: theme.text.body,
        placeholderStyle: theme.text.body.copyWith(
          color: theme.colors.text.withValues(alpha: .5),
        ),
        cursorHeight: 20,
        padding: EdgeInsets.symmetric(horizontal: theme.spacing.medium + 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(theme.radii.field),
          color: theme.colors.translucentBackgroundContrast,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
