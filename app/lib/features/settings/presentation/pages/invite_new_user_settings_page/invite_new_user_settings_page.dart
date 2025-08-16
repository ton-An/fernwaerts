import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/core/l10n/app_localizations.dart';
import 'package:location_history/features/in_app_notification/presentation/cubit/in_app_notification_cubit.dart';
import 'package:location_history/features/settings/presentation/cubits/invite_new_user_cubit/invite_new_user_cubit.dart';
import 'package:location_history/features/settings/presentation/cubits/invite_new_user_cubit/invite_new_user_states.dart';
import 'package:location_history/features/settings/presentation/pages/user_management_settings_page/user_management_settings_page.dart';
import 'package:location_history/features/settings/presentation/widgets/settings_list_view.dart';
import 'package:location_history/features/settings/presentation/widgets/settings_section_title.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

class InviteNewUserSettingsPage extends StatefulWidget {
  const InviteNewUserSettingsPage({super.key});

  static const String pageName = 'invite_new_user_settings';
  static const String route = '${UserManagementSettingsPage.route}/$pageName';

  @override
  State<InviteNewUserSettingsPage> createState() =>
      _InviteNewUserSettingsPageState();
}

class _InviteNewUserSettingsPageState extends State<InviteNewUserSettingsPage> {
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();

    _emailController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);
    return BlocConsumer<InviteNewUserCubit, InviteNewUserState>(
      listener: (BuildContext context, InviteNewUserState state) {
        if (state is InviteNewUserSuccess) {
          context.read<InAppNotificationCubit>().sendSuccessNotification(
            title: AppLocalizations.of(context)!.success,
            message: AppLocalizations.of(context)!.inviteNewUserSuccess,
          );
        }

        if (state is InviteNewUserFailure) {
          context.read<InAppNotificationCubit>().sendFailureNotification(
            state.failure,
          );
        }
      },
      builder: (BuildContext context, InviteNewUserState state) {
        return SettingsListView(
          children: [
            SettingsSectionTitle(
              title: AppLocalizations.of(context)!.inviteNewUser,
              description:
                  AppLocalizations.of(context)!.inviteNewUserDescription,
            ),

            const MediumGap(),

            CustomCupertinoTextField(
              hint: AppLocalizations.of(context)!.usersEmail,
              controller: _emailController,
              onChanged: (_) {},
            ),

            const MediumGap(),
            CustomCupertinoTextButton(
              color: theme.colors.primary,
              isLoading: state is InviteNewUserLoading,
              onPressed:
                  _allowInvite()
                      ? () {
                        context.read<InviteNewUserCubit>().inviteNewUser(
                          email: _emailController.text,
                        );
                      }
                      : null,
              text: AppLocalizations.of(context)!.invite,
            ),
          ],
        );
      },
    );
  }

  bool _allowInvite() {
    if (_emailController.text.isNotEmpty) {
      return true;
    }
    return false;
  }
}
