part of 'gaps.dart';

class XXSmallGap extends StatelessWidget {
  const XXSmallGap({super.key});

  @override
  Widget build(BuildContext context) {
    return Gap(LocationHistoryTheme.of(context).spacing.xxSmall);
  }
}
