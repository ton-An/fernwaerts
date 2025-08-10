import 'package:flutter/cupertino.dart';
import 'package:location_history/core/l10n/app_localizations.dart';
import 'package:location_history/features/authentication/domain/models/user.dart';
import 'package:location_history/features/settings/presentation/pages/main_settings_page/main_settings_page.dart';
import 'package:location_history/features/settings/presentation/widgets/settings_list_view.dart';
import 'package:location_history/features/settings/presentation/widgets/settings_section_title.dart';
import 'package:location_history/features/settings/presentation/widgets/sub_page_link.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

part '_user.dart';

class UserManagementSettingsPage extends StatelessWidget {
  const UserManagementSettingsPage({super.key});

  static const String pageName = 'user_management_settings';
  static const String route = '${MainSettingsPage.route}/$pageName';

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return SettingsListView(
      children: [
        SettingsSectionTitle(
          title: AppLocalizations.of(context)!.userManagement,
          description: AppLocalizations.of(context)!.userManagementDescription,
        ),

        SubSettingsPageLink(
          title: AppLocalizations.of(context)!.createNewUser,
          onPressed: () {},
        ),

        const XXMediumGap(),

        Text(
          AppLocalizations.of(context)!.yourUsers,
          style: theme.text.title3.copyWith(fontWeight: FontWeight.w600),
        ),
        const XXSmallGap(),
        for (final User user in _mockUsers) _User(user: user),
      ],
    );
  }
}

List<User> _mockUsers = [
  User(id: '1', username: 'Moni', email: 'moni@example.com'),
  User(id: '2', username: 'Olli', email: 'olli@example.com'),
];
