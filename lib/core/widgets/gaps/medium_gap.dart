part of 'gaps.dart';

class MediumGap extends StatelessWidget {
  const MediumGap({super.key});

  @override
  Widget build(BuildContext context) {
    return Gap(
      LocationHistoryTheme.of(context).spacing.medium,
    );
  }
}
