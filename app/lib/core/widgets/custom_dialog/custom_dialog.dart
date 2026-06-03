import 'package:flutter/material.dart';
import 'package:location_history/core/widgets/fade_tap_detector.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

part '_button.dart';

/// {@template custom_dialog}
/// Shared confirmation dialog with themed blur, scrim, and two actions.
///
/// Use [show] to display the dialog with the app's scale/fade transition.
/// Submit and cancel callbacks run after the button press animation delay.
/// {@endtemplate}
class CustomDialog extends StatelessWidget {
  /// {@macro custom_dialog}
  const CustomDialog({
    super.key,
    required this.title,
    required this.message,
    required this.submitButtonLabel,
    required this.cancelButtonLabel,
    required this.onSubmit,
    required this.onCancel,
    this.submitButtonSemanticsLabel,
    this.cancelButtonSemanticsLabel,
  });

  final String title;
  final String message;
  final String submitButtonLabel;
  final String cancelButtonLabel;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;
  final String? submitButtonSemanticsLabel;
  final String? cancelButtonSemanticsLabel;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(theme.radii.xMedium)),
        child: BackdropFilter(
          filter: theme.misc.blurFilter,
          child: Container(
            width: 320,
            padding: EdgeInsets.all(theme.spacing.medium + theme.spacing.xTiny),
            color: theme.colors.background.withValues(alpha: .65),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SmallGap(),
                Text(
                  title,
                  style: theme.text.title2.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const XXSmallGap(),
                Text(
                  message,
                  style: theme.text.callout.copyWith(color: theme.colors.hint),
                ),
                const XMediumGap(),

                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Semantics(
                        label: cancelButtonSemanticsLabel,
                        button: true,
                        child: _Button(
                          label: cancelButtonLabel,
                          highlight: false,
                          onPressed: () async {
                            await Future.delayed(theme.durations.xTiny);
                            onCancel();
                          },
                        ),
                      ),
                    ),
                    const XXSmallGap(),
                    Expanded(
                      child: Semantics(
                        label: submitButtonSemanticsLabel,
                        button: true,
                        child: _Button(
                          label: submitButtonLabel,
                          highlight: true,
                          onPressed: () async {
                            await Future.delayed(theme.durations.short);
                            onSubmit();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Presents a [CustomDialog] above [context] using a transparent barrier and
  /// themed transition.
  ///
  /// Parameters:
  /// - context: [BuildContext] used to find theme and Navigator.
  /// - title: [String] dialog title.
  /// - message: [String] dialog body text.
  /// - submitButtonLabel: [String] label for the highlighted action.
  /// - cancelButtonLabel: [String] label for the secondary action.
  /// - onSubmit: [VoidCallback] invoked after the submit animation delay.
  /// - onCancel: [VoidCallback] invoked after the cancel animation delay.
  static void show({
    required BuildContext context,
    required String title,
    required String message,
    required String submitButtonLabel,
    required String cancelButtonLabel,
    required VoidCallback onSubmit,
    required VoidCallback onCancel,
    String? submitButtonSemanticsLabel,
    String? cancelButtonSemanticsLabel,
  }) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    showGeneralDialog(
      context: context,
      barrierColor: Colors.transparent,
      transitionDuration: theme.durations.short,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        final Animation scaleAnimation = Tween<double>(
          begin: 1.15,
          end: 1,
        ).animate(curvedAnimation);

        return Stack(
          children: [
            Container(
              color: theme.colors.backgroundContrast.withValues(
                alpha: .18 * curvedAnimation.value,
              ),
            ),
            Opacity(
              opacity: curvedAnimation.value,
              child: Transform.scale(
                scale:
                    scaleAnimation.isForwardOrCompleted
                        ? scaleAnimation.value
                        : 1,
                child: child,
              ),
            ),
          ],
        );
      },
      pageBuilder: (BuildContext context, animation, secondaryAnimation) {
        return CustomDialog(
          title: title,
          message: message,
          submitButtonLabel: submitButtonLabel,
          cancelButtonLabel: cancelButtonLabel,
          onSubmit: onSubmit,
          onCancel: onCancel,
          submitButtonSemanticsLabel: submitButtonSemanticsLabel,
          cancelButtonSemanticsLabel: cancelButtonSemanticsLabel,
        );
      },
    );
  }
}
