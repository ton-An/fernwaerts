import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:location_history/core/dependency_injector.dart';
import 'package:location_history/core/l10n/app_localizations.dart';
import 'package:location_history/features/authentication/domain/usecases/sign_out.dart';
import 'package:location_history/features/authentication/presentation/pages/authentication_page/authentication_page.dart';
import 'package:location_history/features/map/presentation/pages/map_page/map_page.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

part '_footer.dart';
part '_page_container.dart';
part '_section_title.dart';
part '_sub_page_link.dart';

/*
  To-Do:
    - [ ] Find right style for list items and buttons
*/

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const String pageName = 'settings';
  static const String route = '${MapPage.route}/$pageName';

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return _PageContainer(
      child: Column(
        children: [
          Expanded(
            child: EdgeFade(
              topOptions: const EdgeFadeOptions(enabled: false),
              child: ListView(
                padding: EdgeInsets.only(
                  left: theme.spacing.medium,
                  top: MediaQuery.of(context).padding.top,
                  right: theme.spacing.medium,
                  bottom: theme.spacing.xMedium,
                ),
                children: [
                  _SectionTitle(title: AppLocalizations.of(context)!.general),
                  const _SubPageLink(),
                  const _SubPageLink(),
                  const _SubPageLink(),
                  const XXMediumGap(),
                  CustomCupertinoTextButton(
                    text: AppLocalizations.of(context)!.signOut,
                    textColor: theme.colors.backgroundContrast,
                    color: theme.colors.primaryTranslucent,
                    onPressed: () => _signOut(context),
                  ),
                  const LargeGap(),
                ],
              ),
            ),
          ),
          const _Footer(),
        ],
      ),
    );
  }

  void _signOut(BuildContext context) {
    getIt<SignOut>().call();
    context.go(AuthenticationPage.route);
  }
}
