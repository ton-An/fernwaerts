part of 'gaps.dart';

class XMediumGap extends StatelessWidget {
  const XMediumGap({super.key});

  @override
  Widget build(BuildContext context) {
    return Gap(
      LocationHistoryTheme.of(context).spacing.xMedium,
    );
  }
}
