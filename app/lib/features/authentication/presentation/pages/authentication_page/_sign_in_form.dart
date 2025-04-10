part of 'authentication_page.dart';

class _SignInForm extends StatefulWidget {
  const _SignInForm();

  @override
  State<_SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<_SignInForm> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AuthenticationForm(
      showBackButton: true,
      icon: CupertinoIcons.person_fill,
      label: AppLocalizations.of(context)!.signIn,
      description: AppLocalizations.of(context)!.signInDescription,
      buttonText: AppLocalizations.of(context)!.signIn,
      textFields: [
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
      ],
      onButtonPressed: () {
        context.read<AuthenticationCubit>().signIn(
          _emailController.text,
          _passwordController.text,
        );
      },
      onBackPressed: () {
        context.read<AuthenticationCubit>().toServerDetails();
      },
    );
  }
}
