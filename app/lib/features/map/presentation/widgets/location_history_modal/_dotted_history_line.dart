part of 'location_history_modal.dart';

/// {@template dotted_history_line}
/// A class that represents dotted history line.
/// {@endtemplate}
class _DottedHistoryLine extends StatelessWidget {
/// {@macro dotted_history_line}
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
