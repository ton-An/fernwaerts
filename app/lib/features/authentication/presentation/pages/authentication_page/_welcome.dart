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
            sigma: 20,
            opacity: .3,
            offset: const Offset(7, 7),
            child: Center(
              child: Image.asset(
                "assets/images/app_icon_transparent.png",
                width: 150,
              ),
            ),
          ),
          XMediumGap(),
          Text(
            AppLocalizations.of(context)!.appName,
            textAlign: TextAlign.center,
            style: theme.text.largeTitle.copyWith(fontWeight: FontWeight.w600),
          ),
          SmallGap(),
          Text(
            AppLocalizations.of(context)!.appDescription,
            textAlign: TextAlign.center,
            style: theme.text.body.copyWith(height: 1.45),
          ),
          XXMediumGap(),
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
