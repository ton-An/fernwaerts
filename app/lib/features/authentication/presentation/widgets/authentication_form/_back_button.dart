part of 'authentication_form.dart';

/// {@template back_button}
/// A button widget that handles back actions.
/// {@endtemplate}
class _BackButton extends StatelessWidget {
/// {@macro back_button}
  const _BackButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: SmallIconButton(
            icon: CupertinoIcons.back,
            alignmentOffset: const Offset(-1, 0),
            onPressed: onPressed ?? () {},
          ),
        ),
        const XTinyGap(),
      ],
    );
  }
}
