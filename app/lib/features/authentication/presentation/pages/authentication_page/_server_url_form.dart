part of 'authentication_page.dart';

class _ServerUrlForm extends StatefulWidget {
  const _ServerUrlForm();

  @override
  State<_ServerUrlForm> createState() => _ServerUrlFormState();
}

/// A state class that represents serverurlform state.
class _ServerUrlFormState extends State<_ServerUrlForm> {
  late TextEditingController _urlEditController;

  @override
  void initState() {
    super.initState();
    _urlEditController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationCubitState>(
      builder: (context, state) {
        return AuthenticationForm(
          icon: CupertinoIcons.globe,
          label: AppLocalizations.of(context)!.serverDetails,
          description: AppLocalizations.of(context)!.serverDetailsDescription,
          hint: AppLocalizations.of(context)!.serverDetailsHint,
          buttonText: AppLocalizations.of(context)!.continueButton,
          textFields: [
            CustomCupertinoTextField(
              hint: AppLocalizations.of(context)!.serverUrl,
              controller: _urlEditController,
              onChanged: (_) {},
            ),
          ],
          onButtonPressed: () {
            context.read<AuthenticationCubit>().toAuthDetails(
              serverUrl: _urlEditController.text,
            );
          },
          isLoading: state is AuthenticationLoading,
        );
      },
    );
  }
}
