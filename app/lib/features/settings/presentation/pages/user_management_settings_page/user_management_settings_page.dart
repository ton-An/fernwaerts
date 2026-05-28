import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:location_history/core/l10n/app_localizations.dart';
import 'package:location_history/features/authentication/domain/models/user.dart';
import 'package:location_history/features/settings/presentation/cubits/user_management_cubit/user_management_cubit.dart';
import 'package:location_history/features/settings/presentation/cubits/user_management_cubit/user_management_state.dart';
import 'package:location_history/features/settings/presentation/pages/invite_new_user_settings_page/invite_new_user_settings_page.dart';
import 'package:location_history/features/settings/presentation/pages/main_settings_page/main_settings_page.dart';
import 'package:location_history/features/settings/presentation/widgets/settings_list_view.dart';
import 'package:location_history/features/settings/presentation/widgets/settings_page_link.dart';
import 'package:location_history/features/settings/presentation/widgets/settings_section_title.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

part '_user.dart';

/// {@template user_management_settings_page}
/// Settings page for user administration.
///
/// It links to the invite flow and displays the user rows synced for the
/// current account's permissions.
/// {@endtemplate}
class UserManagementSettingsPage extends StatelessWidget {
  /// {@macro user_management_settings_page}
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

        SettingsPageLink(
          title: AppLocalizations.of(context)!.createNewUser,
          onPressed: () {
            context.push(InviteNewUserSettingsPage.route);
          },
        ),

        const XXMediumGap(),

        Text(
          AppLocalizations.of(context)!.yourUsers,
          style: theme.text.title3.copyWith(fontWeight: FontWeight.w600),
        ),
        const XXSmallGap(),
        BlocBuilder<UserManagementCubit, UserManagementState>(
          builder: (context, state) {
            return switch (state) {
              UserManagementLoaded(:final users) => Column(
                children: [for (final User user in users) _User(user: user)],
              ),
              UserManagementFailure(:final failure) => Text(
                failure.message,
                style: theme.text.body,
              ),
              _ => const CupertinoActivityIndicator(),
            };
          },
        ),
      ],
    );
  }
}
