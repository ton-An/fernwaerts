import 'package:flutter/cupertino.dart';
import 'package:location_history/core/theme/location_history_theme.dart';

class MonthlyCalendar extends StatelessWidget {
  const MonthlyCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    final LocationHistoryThemeData theme = LocationHistoryTheme.of(context);
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          LocationHistoryTheme.of(context).radii.medium,
        ),
        color: theme.colors.translucentBackground,
      ),
      child: Center(
        child: Text(
          'Monthly Calendar',
          style: theme.text.headline.copyWith(color: theme.colors.hint),
        ),
      ),
    );
  }
}
