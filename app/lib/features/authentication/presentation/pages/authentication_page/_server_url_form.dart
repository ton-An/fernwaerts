part of 'authentication_page.dart';

class _ServerUrlForm extends StatefulWidget {
  const _ServerUrlForm();

  @override
  State<_ServerUrlForm> createState() => _ServerUrlFormState();
}

class _ServerUrlFormState extends State<_ServerUrlForm> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

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
          controller: _textEditingController,
          onChanged: (_) {},
        ),
      ],
      onButtonPressed: () {
        context.read<AuthenticationCubit>().toLogInInfo(
          _textEditingController.text,
        );
      },
    );
  }
}
