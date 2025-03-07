part of 'authentication_page.dart';

class _ServerUrlForm extends StatelessWidget {
  const _ServerUrlForm();

  @override
  Widget build(BuildContext context) {
    return AuthenticationForm(
      icon: CupertinoIcons.globe,
      label: AppLocalizations.of(context)!.serverDetails,
      description: AppLocalizations.of(context)!.serverDetailsDescription,
      hint: AppLocalizations.of(context)!.serverDetailsHint,
      buttonText: AppLocalizations.of(context)!.continueButton,
      textFields: [
        CustomCupertinoTextField(
          hint: AppLocalizations.of(context)!.serverUrl,
          onChanged: (_) {},
        ),
      ],
      onButtonPressed: () {
        context.read<AuthenticationCubit>().toLogInInfo("");
      },
    );
  }
}
