part of 'settings_page.dart';

class _SubPageLink extends StatelessWidget {
  const _SubPageLink();

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: theme.spacing.xSmall),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sub Settings Page', style: theme.text.body.copyWith()),
              SmallIconButton(
                icon: CupertinoIcons.forward,
                onPressed: () {},
                alignmentOffset: Offset(1, 0),
              ),
            ],
          ),
        ),
        Container(height: 1, color: theme.colors.translucentBackgroundContrast),
      ],
    );
  }
}
