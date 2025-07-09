import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:location_history/core/dependency_injector.dart';
import 'package:location_history/core/l10n/app_localizations.dart';
import 'package:location_history/features/authentication/domain/usecases/sign_out.dart';
import 'package:location_history/features/authentication/presentation/pages/authentication_page/authentication_page.dart';
import 'package:location_history/features/map/presentation/pages/map_page/map_page.dart';
import 'package:location_history/features/settings/pages/debug_page.dart';
import 'package:location_history/features/settings/widgets/oss_info.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

part '_footer.dart';
part '_page_container.dart';
part '_section_title.dart';
part '_sub_page_link.dart';
part '_version_tag.dart';

/*
  To-Do:
    - [ ] Find right style for list items and buttons
*/

/// {@template settings_page}
/// The main page for application settings.
///
/// This page provides access to various application settings and information.
/// It is structured with sections for general settings, open-source information,
/// and a sign-out button.
///
/// The layout consists of:
/// - **Body**: A scrollable list containing different setting sections and links.
///   - General settings (placeholder links).
///   - [OSSInfo] widget displaying open-source information.
///   - Sign-out button.
/// - **Footer**: Displays application version and build number (via `_Footer`).
///
/// Navigation:
/// - Tapping on sub-page links (placeholders) would navigate to respective settings screens.
/// - Tapping the sign-out button logs the user out and navigates to the [AuthenticationPage].
///
/// Sub-components:
/// - [_PageContainer]: Provides the main container styling for the page.
/// - [_SectionTitle]: Displays titles for different settings sections.
/// - [_SubPageLink]: Represents a tappable link to a sub-settings page (currently placeholders).
/// - [_Footer]: Displays application version information.
/// - [OSSInfo]: A widget to display open-source software information.
/// {@endtemplate}
class SettingsPage extends StatelessWidget {
  /// {@macro settings_page}
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
                  const OSSInfo(),
                  const XXMediumGap(),

                  CustomCupertinoTextButton(
                    text: AppLocalizations.of(context)!.signOut,
                    textColor: theme.colors.backgroundContrast,
                    color: theme.colors.primaryTranslucent,
                    onPressed: () => _signOut(context),
                  ),
                  const XXMediumGap(),
                  const _VersionTag(),
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
