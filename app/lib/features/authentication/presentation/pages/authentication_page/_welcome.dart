part of 'authentication_page.dart';

class _Welcome extends StatelessWidget {
  const _Welcome();

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return Container(
      padding: EdgeInsets.only(
        left: theme.spacing.xMedium,
        right: theme.spacing.xMedium,
        top: theme.spacing.xxMedium,
        bottom:
            MediaQuery.of(context).viewPadding.bottom + theme.spacing.medium,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SimpleShadow(
            sigma: 6,
            opacity: .3,
            offset: const Offset(-4, 4),
            child: Center(
              child: Image.asset(
                'assets/images/app_icons/app_icon_transparent_new.png',
                width: 150,
              ),
            ),
          ),
          const XMediumGap(),
          Text(
            AppLocalizations.of(context)!.appName,
            textAlign: TextAlign.center,
            style: theme.text.largeTitle.copyWith(fontWeight: FontWeight.w600),
          ),
          const SmallGap(),
          Text(
            AppLocalizations.of(context)!.appDescription,
            textAlign: TextAlign.center,
            style: theme.text.body.copyWith(height: 1.45),
          ),
          const XXMediumGap(),
          CustomCupertinoTextButton(
            text: AppLocalizations.of(context)!.getStarted,
            onPressed: () {
              context.read<AuthenticationCubit>().toServerDetails();
            },
          ),
        ],
      ),
    );
  }
}
