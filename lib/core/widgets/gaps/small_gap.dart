part of 'gaps.dart';

class SmallGap extends StatelessWidget {
  const SmallGap({super.key});

  @override
  Widget build(BuildContext context) {
    return Gap(LocationHistoryTheme.of(context).spacing.small);
  }
}
