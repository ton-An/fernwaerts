part of 'authentication_page.dart';

class _AdminSignUpForm extends StatefulWidget {
  const _AdminSignUpForm();

  @override
  State<_AdminSignUpForm> createState() => _AdminSignUpFormState();
}

class _AdminSignUpFormState extends State<_AdminSignUpForm> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        return AuthenticationForm(
          showBackButton: true,
          icon: CupertinoIcons.person_fill,
          label: AppLocalizations.of(context)!.createAdmin,
          description: AppLocalizations.of(context)!.adminSignUpDescription,
          buttonText: AppLocalizations.of(context)!.createAdmin,
          buttonSemanticsLabel:
              AppLocalizations.of(context)!.semanticCreateAdminButton,
          textFields: [
            CustomCupertinoTextField(
              hint: AppLocalizations.of(context)!.username,
              semanticLabel:
                  AppLocalizations.of(context)!.semanticAdminUsernameField,
              controller: _usernameController,
              autofillHints: const [AutofillHints.newUsername],
              onChanged: (_) {},
            ),
            CustomCupertinoTextField(
              hint: AppLocalizations.of(context)!.email,
              semanticLabel:
                  AppLocalizations.of(context)!.semanticAdminEmailField,
              controller: _emailController,
              autofillHints: const [AutofillHints.email],
              keyboardType: TextInputType.emailAddress,
              onChanged: (_) {},
            ),
            CustomCupertinoTextField(
              hint: AppLocalizations.of(context)!.password,
              semanticLabel:
                  AppLocalizations.of(context)!.semanticAdminPasswordField,
              controller: _passwordController,
              autofillHints: const [AutofillHints.newPassword],
              obscureText: true,
              onChanged: (_) {},
            ),
            CustomCupertinoTextField(
              hint: AppLocalizations.of(context)!.confirmPassword,
              semanticLabel:
                  AppLocalizations.of(
                    context,
                  )!.semanticAdminConfirmPasswordField,
              controller: _confirmPasswordController,
              autofillHints: const [AutofillHints.newPassword],
              obscureText: true,
              onChanged: (_) {},
            ),
          ],
          onButtonPressed: () {
            context.read<AuthenticationCubit>().signUpAdmin(
              username: _usernameController.text,
              email: _emailController.text,
              password: _passwordController.text,
              repeatedPassword: _confirmPasswordController.text,
            );
          },
          onBackPressed: () {
            context.read<AuthenticationCubit>().toServerDetails();
          },
          isLoading: state is AuthenticationLoading,
        );
      },
    );
  }
}
