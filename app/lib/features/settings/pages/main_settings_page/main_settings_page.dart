import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:location_history/core/dependency_injector.dart';
import 'package:location_history/core/l10n/app_localizations.dart';
import 'package:location_history/core/widgets/custom_dialog/custom_dialog.dart';
import 'package:location_history/core/widgets/small_text_button.dart';
import 'package:location_history/features/authentication/domain/usecases/sign_out.dart';
import 'package:location_history/features/authentication/presentation/pages/authentication_page/authentication_page.dart';
import 'package:location_history/features/map/presentation/pages/map_page/map_page.dart';
import 'package:location_history/features/settings/pages/account_settings_page/account_settings_page.dart';
import 'package:location_history/features/settings/pages/debug_page.dart';
import 'package:location_history/features/settings/widgets/oss_info.dart';
import 'package:location_history/features/settings/widgets/settings_list_view.dart';
import 'package:location_history/features/settings/widgets/settings_section_title.dart';
import 'package:location_history/features/settings/widgets/sub_page_link.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

part '_version_tag.dart';

/*
  To-Do:
    - [ ] re-add docs
    - [ ] Find right style for list items and buttons
    - [ ] Implement proper log out flow
*/
class MainSettingsPage extends StatelessWidget {
  /// {@macro settings_page}
  const MainSettingsPage({super.key});

  static const String pageName = 'settings';
  static const String route = '${MapPage.route}/$pageName';

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return SettingsListView(
      children: [
        SettingsSectionTitle(title: AppLocalizations.of(context)!.account),
        SubSettingsPageLink(
          title: AppLocalizations.of(context)!.personalInformation,
          onPressed: () {},
        ),
        SubSettingsPageLink(
          title: AppLocalizations.of(context)!.authentication,
          onPressed: () {
            context.go(AccountSettingsPage.route);
          },
        ),
        const XXMediumGap(),
        SettingsSectionTitle(title: AppLocalizations.of(context)!.admin),
        SubSettingsPageLink(
          title: AppLocalizations.of(context)!.userManagement,
          onPressed: () {},
        ),
        const XXMediumGap(),
        const OSSInfo(),
        const XXMediumGap(),
        CustomCupertinoTextButton(
          text: AppLocalizations.of(context)!.signOut,
          textColor: theme.colors.backgroundContrast.withValues(alpha: .75),
          color: theme.colors.translucentBackgroundContrast.withValues(
            alpha: .16,
          ),
          onPressed: () => _signOut(context),
        ),
        const XXMediumGap(),
        const _VersionTag(),
        const LargeGap(),
      ],
    );
  }

  void _signOut(BuildContext context) {
    CustomDialog.show(
      context: context,
      title: AppLocalizations.of(context)!.signOutQuestion,
      message: AppLocalizations.of(context)!.signOutMessage,
      submitButtonLabel: AppLocalizations.of(context)!.yes,
      cancelButtonLabel: AppLocalizations.of(context)!.cancel,
      onSubmit: () {
        getIt<SignOut>().call();
        context.pop();
        context.go(AuthenticationPage.route);
      },
      onCancel: () {
        context.pop();
      },
    );
  }
}
