part of 'authentication_page.dart';

class _SignInForm extends StatelessWidget {
  const _SignInForm();

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
          hint: AppLocalizations.of(context)!.username,
          onChanged: (_) {},
        ),
        CustomCupertinoTextField(
          hint: AppLocalizations.of(context)!.password,
          onChanged: (_) {},
        ),
      ],
      onButtonPressed: () {
        context.read<AuthenticationCubit>().logIn("", "");
      },
      onBackPressed: () {
        context.read<AuthenticationCubit>().toServerDetails();
      },
    );
  }
}
