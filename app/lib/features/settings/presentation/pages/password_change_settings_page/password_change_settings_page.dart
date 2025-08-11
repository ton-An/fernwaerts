import 'package:flutter/material.dart';
import 'package:location_history/core/l10n/app_localizations.dart';
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
  late TextEditingController _oldPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _newRepeatedPasswordController;

  @override
  void initState() {
    super.initState();
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _newRepeatedPasswordController = TextEditingController();

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
    return SettingsListView(
      children: [
        SettingsSectionTitle(
          title: AppLocalizations.of(context)!.passwordChange,
          description: AppLocalizations.of(context)!.passwordChangeDescription,
        ),

        const MediumGap(),

        CustomCupertinoTextField(
          hint: AppLocalizations.of(context)!.oldPassword,
          controller: _oldPasswordController,
          obscureText: true,
          onChanged: (_) {},
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

        const XXSmallGap(),

        _MismatchedPasswordsError(
          display: _displayMismatchedNewPasswordError(),
        ),

        const MediumGap(),
        CustomCupertinoButton(
          color: theme.colors.primary,
          isLoading: false,
          onPressed: _allowSave() ? () {} : null,
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
  }

  bool _displayMismatchedNewPasswordError() {
    if (_newPasswordController.text.isEmpty ||
        _newRepeatedPasswordController.text.isEmpty) {
      return false;
    }

    return _newPasswordController.text != _newRepeatedPasswordController.text;
  }

  bool _allowSave() {
    return false;
  }
}
