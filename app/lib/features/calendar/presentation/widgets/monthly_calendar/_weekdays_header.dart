part of 'monthly_calendar.dart';

/// {@template weekdays_header}
/// A header row that displays the abbreviated weekday names.
///
/// This widget renders the weekday abbreviations (e.g., M, T, W, T, F, S, S)
/// as a header row for the monthly calendar grid.
/// {@endtemplate}
class _WeekdaysHeader extends StatelessWidget {
  /// {@macro weekdays_header}
  const _WeekdaysHeader();

  @override
  Widget build(BuildContext context) {
    final List<String> weekdays =
        DateFormat.EEEEE(
          Localizations.localeOf(context).languageCode,
        ).dateSymbols.SHORTWEEKDAYS;

    return Row(
      children: [
        const Expanded(child: SizedBox()),
        for (int i = 0; i < weekdays.length; i++)
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: Center(
                child: Text(
                  weekdays[(i + 1) % 7].toUpperCase(),
                  style: WebfabrikTheme.of(
                    context,
                  ).text.footnote.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
