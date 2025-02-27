import 'package:flutter/cupertino.dart';
import 'package:location_history/core/theme/location_history_theme.dart';

class CustomCupertinoButton extends StatelessWidget {
  const CustomCupertinoButton({
    super.key,
    required this.child,
    this.disabledColor,
    this.onPressed,
  });

  final Widget child;
  final Color? disabledColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final LocationHistoryThemeData theme = LocationHistoryTheme.of(context);

    return CupertinoButton(
      color: theme.colors.primary.withValues(alpha: .8),
      disabledColor: disabledColor ?? theme.colors.disabledButton,
      borderRadius: BorderRadius.circular(
        theme.radii.button,
      ),
      minSize: 52,
      onPressed: onPressed,
      child: child,
    );
  }
}
