part of 'invite_page.dart';

class _InviteForm extends StatefulWidget {
  const _InviteForm();

  @override
  State<_InviteForm> createState() => _InviteFormState();
}

class _InviteFormState extends State<_InviteForm> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InviteCubit, InviteState>(
      builder: (context, state) {
        return AuthenticationForm(
          icon: CupertinoIcons.person_fill,
          label: AppLocalizations.of(context)!.acceptInvite,
          description: AppLocalizations.of(context)!.acceptInviteDescription,
          buttonText: AppLocalizations.of(context)!.accept,
          buttonSemanticsLabel:
              AppLocalizations.of(context)!.semanticAcceptInviteButton,
          textFields: [
            Semantics(
              label: AppLocalizations.of(context)!.semanticInviteUsernameField,
              textField: true,
              child: CustomCupertinoTextField(
                hint: AppLocalizations.of(context)!.username,
                controller: _usernameController,
                autofillHints: const [AutofillHints.newUsername],
                onChanged: (_) {},
              ),
            ),
            Semantics(
              label: AppLocalizations.of(context)!.semanticInvitePasswordField,
              textField: true,
              child: CustomCupertinoTextField(
                hint: AppLocalizations.of(context)!.password,
                controller: _passwordController,
                autofillHints: const [AutofillHints.newPassword],
                obscureText: true,
                onChanged: (_) {},
              ),
            ),
            Semantics(
              label:
                  AppLocalizations.of(
                    context,
                  )!.semanticInviteConfirmPasswordField,
              textField: true,
              child: CustomCupertinoTextField(
                hint: AppLocalizations.of(context)!.confirmPassword,
                controller: _confirmPasswordController,
                autofillHints: const [AutofillHints.newPassword],
                obscureText: true,
                onChanged: (_) {},
              ),
            ),
          ],
          onButtonPressed: () {
            context.read<InviteCubit>().acceptInvite(
              username: _usernameController.text,
              password: _passwordController.text,
            );
          },
          isLoading: state is InviteLoading,
        );
      },
    );
  }
}
