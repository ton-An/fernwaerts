import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:location_history/core/dependency_injector.dart';
import 'package:location_history/core/l10n/app_localizations.dart';
import 'package:location_history/core/widgets/custom_dialog/custom_dialog.dart';
import 'package:location_history/core/widgets/small_text_button.dart';
import 'package:location_history/features/authentication/domain/usecases/sign_out.dart';
import 'package:location_history/features/authentication/presentation/pages/authentication_page/authentication_page.dart';
import 'package:location_history/features/map/presentation/pages/map_page/map_page.dart';
import 'package:location_history/features/settings/presentation/pages/account_settings_page/account_settings_page.dart';
import 'package:location_history/features/settings/presentation/pages/debug_page.dart';
import 'package:location_history/features/settings/presentation/pages/user_management_settings_page/user_management_settings_page.dart';
import 'package:location_history/features/settings/presentation/widgets/open_source_info.dart';
import 'package:location_history/features/settings/presentation/widgets/settings_list_view.dart';
import 'package:location_history/features/settings/presentation/widgets/settings_section_title.dart';
import 'package:location_history/features/settings/presentation/widgets/settings_page_link.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

part '_version_tag.dart';

/*
  To-Do:
    - [ ] Find right style for list items and buttons
    - [ ] Consider awaiting sign-out only if we need to block navigation on failure
*/
/// {@template main_settings_page}
/// Root settings page shown from the map route.
///
/// It links to account and user-management settings, displays open-source and
/// version information, confirms the sign-out dialog, then starts sign-out and
/// returns to [AuthenticationPage] immediately.
/// {@endtemplate}
class MainSettingsPage extends StatelessWidget {
  /// {@macro main_settings_page}
  const MainSettingsPage({super.key});

  static const String pageName = 'settings';
  static const String route = '${MapPage.route}/$pageName';

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return SettingsListView(
      children: [
        SettingsSectionTitle(title: AppLocalizations.of(context)!.account),
        Semantics(
          label: AppLocalizations.of(context)!.semanticAccountSettingsLink,
          button: true,
          child: SettingsPageLink(
            title: AppLocalizations.of(context)!.authentication,
            onPressed: () {
              context.go(AccountSettingsPage.route);
            },
          ),
        ),
        const XXMediumGap(),

        SettingsSectionTitle(title: AppLocalizations.of(context)!.admin),
        Semantics(
          label: AppLocalizations.of(context)!.semanticUserManagementLink,
          button: true,
          child: SettingsPageLink(
            title: AppLocalizations.of(context)!.userManagement,
            onPressed: () {
              context.go(UserManagementSettingsPage.route);
            },
          ),
        ),
        const XXMediumGap(),
        const OpenSourceInfo(),
        const XXMediumGap(),
        Semantics(
          label: AppLocalizations.of(context)!.semanticSignOutButton,
          button: true,
          child: CustomCupertinoTextButton(
            text: AppLocalizations.of(context)!.signOut,
            textColor: theme.colors.backgroundContrast.withValues(alpha: .75),
            color: theme.colors.translucentBackgroundContrast.withValues(
              alpha: .16,
            ),
            onPressed: () => _signOut(context),
          ),
        ),
        const XXMediumGap(),
        const _VersionTag(),
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
      submitButtonSemanticsLabel:
          AppLocalizations.of(context)!.semanticConfirmDialogActionButton,
      cancelButtonSemanticsLabel:
          AppLocalizations.of(context)!.semanticCancelDialogActionButton,
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
