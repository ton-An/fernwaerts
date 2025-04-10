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
    return AuthenticationForm(
      showBackButton: true,
      icon: CupertinoIcons.person_fill,
      label: AppLocalizations.of(context)!.createAdmin,
      description: AppLocalizations.of(context)!.adminSignUpDescription,
      buttonText: AppLocalizations.of(context)!.createAdmin,
      textFields: [
        CustomCupertinoTextField(
          hint: AppLocalizations.of(context)!.username,
          controller: _usernameController,
          onChanged: (_) {},
        ),
        CustomCupertinoTextField(
          hint: AppLocalizations.of(context)!.email,
          controller: _emailController,
          onChanged: (_) {},
        ),
        CustomCupertinoTextField(
          hint: AppLocalizations.of(context)!.password,
          controller: _passwordController,
          obscureText: true,
          onChanged: (_) {},
        ),
        CustomCupertinoTextField(
          hint: AppLocalizations.of(context)!.confirmPassword,
          controller: _confirmPasswordController,
          obscureText: true,
          onChanged: (_) {},
        ),
      ],
      onButtonPressed: () {
        context.read<AuthenticationCubit>().signUpAdmin(
          _usernameController.text,
          _emailController.text,
          _passwordController.text,
          _confirmPasswordController.text,
        );
      },
      onBackPressed: () {
        context.read<AuthenticationCubit>().toServerDetails();
      },
    );
  }
}
