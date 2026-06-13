part of 'custom_dialog.dart';

class _Button extends StatelessWidget {
  const _Button({
    required this.label,
    required this.highlight,
    required this.onPressed,
    required this.semanticLabel,
  });

  final String label;
  final bool highlight;
  final VoidCallback onPressed;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return FadeTapDetector(
      semanticLabel: semanticLabel,
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: theme.spacing.xxSmall),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(theme.radii.small),
          color: theme.colors.translucentBackgroundContrast,
        ),
        child: Center(
          child: Text(
            label,
            style: theme.text.headline.copyWith(
              color: highlight ? theme.colors.error : null,
            ),
          ),
        ),
      ),
    );
  }
}
