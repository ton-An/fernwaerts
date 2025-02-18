part of 'gaps.dart';

class XLargeGap extends StatelessWidget {
  const XLargeGap({super.key});

  @override
  Widget build(BuildContext context) {
    return Gap(LocationHistoryTheme.of(context).spacing.xLarge);
  }
}
