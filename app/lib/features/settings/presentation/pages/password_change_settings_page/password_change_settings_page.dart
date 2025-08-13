import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/core/failures/authentication/need_otp_reauthentication_failure.dart';
import 'package:location_history/core/l10n/app_localizations.dart';
import 'package:location_history/features/in_app_notification/presentation/cubit/in_app_notification_cubit.dart';
import 'package:location_history/features/settings/presentation/cubits/password_change_cubit/password_change_cubit.dart';
import 'package:location_history/features/settings/presentation/cubits/password_change_cubit/password_change_states.dart';
import 'package:location_history/features/settings/presentation/pages/account_settings_page/account_settings_page.dart';
import 'package:location_history/features/settings/presentation/widgets/settings_list_view.dart';
import 'package:location_history/features/settings/presentation/widgets/settings_section_title.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

part '_mismatched_passwords_error.dart';

class PasswordChangeSettingsPage extends StatefulWidget {
  const PasswordChangeSettingsPage({super.key});

  static const String pageName = 'password_change_settings';
  static const String route = '${AccountSettingsPage.route}/$pageName';

  @override
  State<PasswordChangeSettingsPage> createState() =>
      _PasswordChangeSettingsPageState();
}

class _PasswordChangeSettingsPageState
    extends State<PasswordChangeSettingsPage> {
  late TextEditingController _newPasswordController;
  late TextEditingController _newRepeatedPasswordController;
  late TextEditingController _otpController;

  bool _displayOTPField = false;

  @override
  void initState() {
    super.initState();
    _newPasswordController = TextEditingController();
    _newRepeatedPasswordController = TextEditingController();
    _otpController = TextEditingController();

    _newPasswordController.addListener(() {
      setState(() {});
    });

    _newRepeatedPasswordController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);
    return BlocConsumer<PasswordChangeCubit, PasswordChangeState>(
      listener: (BuildContext context, PasswordChangeState state) {
        if (state is PasswordChangeSuccess) {
          context.read<InAppNotificationCubit>().sendSuccessNotification(
            title: AppLocalizations.of(context)!.success,
            message: AppLocalizations.of(context)!.passwordChangeSuccess,
          );
        }

        if (state is PasswordChangeFailure) {
          if (state.failure is NeedOtpReauthenticationFailure) {
            setState(() {
              _displayOTPField = true;
            });
          }

          context.read<InAppNotificationCubit>().sendFailureNotification(
            state.failure,
          );
        }
      },
      builder: (BuildContext context, PasswordChangeState state) {
        return SettingsListView(
          children: [
            SettingsSectionTitle(
              title: AppLocalizations.of(context)!.passwordChange,
              description:
                  AppLocalizations.of(context)!.passwordChangeDescription,
            ),

            const MediumGap(),

            CustomCupertinoTextField(
              hint: AppLocalizations.of(context)!.newPassword,
              controller: _newPasswordController,
              obscureText: true,
              onChanged: (_) {},
            ),

            const MediumGap(),

            CustomCupertinoTextField(
              hint: AppLocalizations.of(context)!.confirmNewPassword,
              controller: _newRepeatedPasswordController,
              obscureText: true,
              onChanged: (_) {},
            ),

            if (_displayOTPField) ...[
              const MediumGap(),

              CustomCupertinoTextField(
                hint: AppLocalizations.of(context)!.otpPassword,
                controller: _otpController,
                onChanged: (_) {},
              ),
            ],

            const XXSmallGap(),

            _MismatchedPasswordsError(
              display: _displayMismatchedNewPasswordError(),
            ),

            const MediumGap(),
            CustomCupertinoButton(
              color: theme.colors.primary,
              isLoading: state is PasswordChangeLoading,
              onPressed:
                  _allowSave()
                      ? () {
                        context.read<PasswordChangeCubit>().changePassword(
                          newPassword: _newPasswordController.text,
                          otp:
                              _otpController.text.isNotEmpty
                                  ? _otpController.text
                                  : null,
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

  bool _displayMismatchedNewPasswordError() {
    if (_newPasswordController.text.isEmpty ||
        _newRepeatedPasswordController.text.isEmpty) {
      return false;
    }

    return _newPasswordController.text != _newRepeatedPasswordController.text;
  }

  bool _allowSave() {
    if (_newPasswordController.text.isEmpty ||
        _newRepeatedPasswordController.text.isEmpty) {
      return false;
    }

    return _newPasswordController.text == _newRepeatedPasswordController.text;
  }
}
