import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/core/widgets/fade_tap_detector.dart';
import 'package:location_history/features/in_app_notification/presentation/cubit/in_app_notification.dart';
import 'package:location_history/features/in_app_notification/presentation/cubit/in_app_notification_cubit.dart';
import 'package:location_history/features/in_app_notification/presentation/cubit/in_app_notification_states.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

part '_content.dart';
part '_decoration.dart';
part '_dismissible.dart';
part '_fade_wrapper.dart';

/*
  To-Dos:
  - [ ] Move durations to theme
  - [ ] Clear up naming of the whole in app notification feature
  - [ ] Add a toast like notification when the failure has been copied to clipboard
*/

/// {@template in_app_notification}
/// Displays one in-app notification overlay entry.
///
/// Failure notifications show the failure name and message; success
/// notifications show their provided title and message. A long press copies
/// failure details to the clipboard. Success notifications do not copy anything.
///
/// Sub-components:
/// - [_FadeWrapper]: Fades out the current entry before replacement.
/// - [_Dismissible]: Handles entry motion and upward swipe dismissal.
/// - [_Decoration]: Applies the translucent notification container styling.
/// - [_Content]: Maps the notification model to icon, color, title, and message.
/// {@endtemplate}
class InAppNotificationWidget extends StatelessWidget {
  /// {@macro in_app_notification}
  const InAppNotificationWidget({required this.notification, super.key});

  /// Notification content to display.
  final InAppNotification notification;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return FadeTapDetector(
      behavior: HitTestBehavior.deferToChild,
      onLongPress: () {
        if (notification is InAppFailureNotification) {
          Clipboard.setData(
            ClipboardData(
              text:
                  (notification as InAppFailureNotification).failure.toString(),
            ),
          );
        }
      },
      child: _FadeWrapper(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Dismissible(
              dismissThreshold: .17,
              onDismissed:
                  () =>
                      context
                          .read<InAppNotificationCubit>()
                          .dismissNotification(),
              movementDuration: theme.durations.xMedium,
              reverseMovementDuration: theme.durations.xHuge,
              entryDuration: theme.durations.long,
              key: GlobalKey(),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: theme.spacing.medium,
                    vertical: theme.spacing.small,
                  ),
                  child: _Decoration(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: theme.spacing.xMedium,
                        vertical: theme.spacing.medium,
                      ),
                      child: _Content(notification: notification),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
