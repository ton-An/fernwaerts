part of 'authentication_page.dart';

class _AdminSignUpForm extends StatelessWidget {
  const _AdminSignUpForm();

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
          onChanged: (_) {},
        ),
        CustomCupertinoTextField(
          hint: AppLocalizations.of(context)!.email,
          onChanged: (_) {},
        ),
        CustomCupertinoTextField(
          hint: AppLocalizations.of(context)!.password,
          onChanged: (_) {},
        ),
        CustomCupertinoTextField(
          hint: AppLocalizations.of(context)!.confirmPassword,
          onChanged: (_) {},
        ),
      ],
      onButtonPressed: () {
        context.read<AuthenticationCubit>().signUpAdmin("", "", "", "");
      },
      onBackPressed: () {
        context.read<AuthenticationCubit>().toServerDetails();
      },
    );
  }
}
