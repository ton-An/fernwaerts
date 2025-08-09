import 'package:flutter/material.dart';
import 'package:location_history/core/widgets/fade_tap_detector.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

part '_button.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.title,
    required this.message,
    required this.submitButtonLabel,
    required this.cancelButtonLabel,
    required this.onSubmit,
    required this.onCancel,
  });

  final String title;
  final String message;
  final String submitButtonLabel;
  final String cancelButtonLabel;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

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
                      child: _Button(
                        label: cancelButtonLabel,
                        highlight: false,
                        onPressed: onCancel,
                      ),
                    ),
                    const XXSmallGap(),
                    Expanded(
                      child: _Button(
                        label: submitButtonLabel,
                        highlight: true,
                        onPressed: onSubmit,
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

  static void show({
    required BuildContext context,
    required String title,
    required String message,
    required String submitButtonLabel,
    required String cancelButtonLabel,
    required VoidCallback onSubmit,
    required VoidCallback onCancel,
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
          reverseCurve: Curves.easeIn,
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
        );
      },
    );
  }
}
