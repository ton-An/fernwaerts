import 'package:flutter/cupertino.dart';
import 'package:location_history/core/theme/location_history_theme.dart';

class Dot extends StatelessWidget {
  const Dot({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: 3,
      decoration: BoxDecoration(
        color: LocationHistoryTheme.of(context).colors.hint,
        shape: BoxShape.circle,
      ),
    );
  }
}
