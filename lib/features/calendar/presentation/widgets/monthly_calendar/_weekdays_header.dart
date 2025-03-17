part of 'monthly_calendar.dart';

class _WeekdaysHeader extends StatelessWidget {
  const _WeekdaysHeader();

  @override
  Widget build(BuildContext context) {
    final List<String> weekdays =
        DateFormat.EEEEE(Localizations.localeOf(context).languageCode)
            .dateSymbols
            .SHORTWEEKDAYS;

    return Row(children: [
      Expanded(child: SizedBox()),
      for (int i = 0; i < weekdays.length; i++)
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: Center(
              child: Text(
                weekdays[(i + 1) % 7].toUpperCase(),
                style: WebfabrikTheme.of(context).text.footnote.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
        ),
    ]);
  }
}
