part of 'location_history_modal.dart';

class _DottedHistoryLine extends StatelessWidget {
  const _DottedHistoryLine();

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);
    return SizedBox(
      height: 120,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: DottedLine(
          dashLength: 12,
          lineThickness: 6,
          dashGapLength: 12,
          dashColor: theme.colors.translucentBackgroundContrast,
          dashRadius: 2,
          direction: Axis.vertical,
        ),
      ),
    );
  }
}
