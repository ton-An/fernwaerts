part of 'calendar.dart';

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({
    required this.label,
    required this.onPreviousPressed,
    required this.onNextPressed,
  });

  final String label;
  final VoidCallback onPreviousPressed;
  final VoidCallback onNextPressed;

  @override
  Widget build(BuildContext context) {
    final theme = LocationHistoryTheme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _Switch(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () {},
        ),
        Expanded(
          child: Center(
            child: Text(
              label,
              style: theme.text.title3.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        _Switch(
          icon: Icons.arrow_forward_ios_rounded,
          onPressed: () {},
        ),
      ],
    );
  }
}
