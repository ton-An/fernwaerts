import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:location_history/core/l10n/app_localizations.dart';
import 'package:location_history/features/in_app_notification/presentation/cubit/in_app_notification_cubit.dart';
import 'package:location_history/features/settings/presentation/cubits/account_settings_cubit/account_settings_cubit.dart';
import 'package:location_history/features/settings/presentation/cubits/account_settings_cubit/account_settings_states.dart';
import 'package:location_history/features/settings/presentation/pages/main_settings_page/main_settings_page.dart';
import 'package:location_history/features/settings/presentation/pages/password_change_settings_page/password_change_settings_page.dart';
import 'package:location_history/features/settings/presentation/widgets/settings_list_view.dart';
import 'package:location_history/features/settings/presentation/widgets/settings_section_title.dart';
import 'package:location_history/features/settings/presentation/widgets/sub_page_link.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  static const String pageName = 'account_settings';
  static const String route = '${MainSettingsPage.route}/$pageName';

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
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
    return BlocConsumer<AccountSettingsCubit, AccountSettingsState>(
      listener: (BuildContext context, AccountSettingsState state) {
        if (state is VerificationEmailSent) {
          context.read<InAppNotificationCubit>().sendSuccessNotification(
            title: AppLocalizations.of(context)!.emailSent,
            message:
                AppLocalizations.of(context)!.checkInboxForVerificationMail,
          );
        }

        if (state is AccountSettingsFailure) {
          context.read<InAppNotificationCubit>().sendFailureNotification(
            state.failure,
          );
        }
      },
      builder: (BuildContext context, AccountSettingsState state) {
        return SettingsListView(
          children: [
            SettingsSectionTitle(
              title: AppLocalizations.of(context)!.authentication,
              description:
                  AppLocalizations.of(context)!.authenticationDescription,
            ),

            const MediumGap(),

            CustomCupertinoTextField(
              hint: AppLocalizations.of(context)!.newEmailAddress,
              controller: _emailController,
              onChanged: (_) {},
            ),

            const MediumGap(),

            SubSettingsPageLink(
              title: AppLocalizations.of(context)!.changePassword,
              onPressed: () {
                context.go(PasswordChangeSettingsPage.route);
              },
            ),

            const XXMediumGap(),
            CustomCupertinoButton(
              color: theme.colors.primary,
              isLoading: state is SendingVerificationEmail,
              onPressed:
                  _allowSave()
                      ? () {
                        context.read<AccountSettingsCubit>().updateEmail(
                          _emailController.text..trim(),
                        );
                      }
                      : null,
              child: Text(
                AppLocalizations.of(context)!.save,
                textAlign: TextAlign.center,
                style: theme.text.headline.copyWith(
                  color: theme.colors.primaryContrast,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  bool _allowSave() {
    return _emailController.text.isNotEmpty;
  }
}
