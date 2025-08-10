import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:location_history/core/l10n/app_localizations.dart';
import 'package:location_history/features/settings/presentation/pages/account_settings_page/account_settings_page.dart';
import 'package:location_history/features/settings/presentation/pages/main_settings_page/main_settings_page.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

part '_footer.dart';

class SettingsPageWrapper extends StatelessWidget {
  const SettingsPageWrapper({
    super.key,
    required this.pagePath,
    required this.child,
  });

  final String? pagePath;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(theme.radii.medium),
      ),
      child: BackdropFilter(
        filter: theme.misc.blurFilter,
        child: SafeArea(
          top: false,
          child: Container(
            decoration: BoxDecoration(
              color: theme.colors.translucentBackground,
              borderRadius: BorderRadius.circular(theme.radii.xLarge),
            ),
            child: Column(
              children: [
                Expanded(
                  child: EdgeFade(
                    topOptions: const EdgeFadeOptions(enabled: false),
                    bottomOptions: const EdgeFadeOptions(
                      halfWayPoint: .3,
                      heightFactor: .07,
                    ),
                    child: child,
                  ),
                ),
                _Footer(
                  title: _getPageTitle(context: context),
                  isMainPage: pagePath == MainSettingsPage.route,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getPageTitle({required BuildContext context}) {
    if (pagePath == AccountSettingsPage.route) {
      return AppLocalizations.of(context)!.account;
    }

    return AppLocalizations.of(context)!.settings;
  }
}
