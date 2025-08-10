import 'package:flutter/material.dart';
import 'package:location_history/core/l10n/app_localizations.dart';
import 'package:location_history/features/settings/pages/main_settings_page/main_settings_page.dart';
import 'package:location_history/features/settings/widgets/settings_list_view.dart';
import 'package:location_history/features/settings/widgets/settings_section_title.dart';
import 'package:location_history/features/settings/widgets/sub_page_link.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  static const String pageName = 'account_settings';
  static const String route = '${MainSettingsPage.route}/$pageName';

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);
    return SettingsListView(
      children: [
        SettingsSectionTitle(
          title: AppLocalizations.of(context)!.authentication,
          description: AppLocalizations.of(context)!.authenticationDescription,
        ),

        const MediumGap(),

        CustomCupertinoTextField(
          hint: AppLocalizations.of(context)!.email,
          onChanged: (_) {},
        ),

        const MediumGap(),

        SubSettingsPageLink(
          title: AppLocalizations.of(context)!.changePassword,
          onPressed: () {},
        ),

        const XXMediumGap(),
        CustomCupertinoTextButton(
          text: AppLocalizations.of(context)!.save,
          color: theme.colors.primary,
          // onPressed: () {},
        ),
      ],
    );
  }
}
