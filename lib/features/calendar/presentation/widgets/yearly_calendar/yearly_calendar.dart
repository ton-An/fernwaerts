import 'package:flutter/cupertino.dart';
import 'package:location_history/core/theme/location_history_theme.dart';

class YearlyCalendar extends StatelessWidget {
  const YearlyCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      color: LocationHistoryTheme.of(context).colors.primary,
      child: Text('Yearly Calendar'),
    );
  }
}
