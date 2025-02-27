import 'package:flutter/cupertino.dart';
import 'package:location_history/core/theme/location_history_theme.dart';
import 'package:location_history/core/widgets/custom_cupertino_button.dart';

/// __Custom Cupertino Text Button__
///
/// A button that is styled like a Cupertino text button.
class CustomCupertinoTextButton extends StatelessWidget {
  const CustomCupertinoTextButton({
    super.key,
    required this.text,
    this.disabledColor,
    this.onPressed,
  });

  final String text;
  final Color? disabledColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final LocationHistoryThemeData theme = LocationHistoryTheme.of(context);

    return CustomCupertinoButton(
      disabledColor: disabledColor,
      onPressed: onPressed,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: theme.text.headline.copyWith(
          color: theme.colors.primaryContrast,
        ),
      ),
    );
  }
}
