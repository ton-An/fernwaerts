import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/core/failures/failure.dart';
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
/// A widget that displays an in-app notification, typically for errors or alerts.
///
/// This widget is designed to show a [Failure] object to the user.
/// It includes the following components:
/// - **Fade Transition**: Animates the appearance and disappearance of the notification.
/// - **Dismissible Area**: Allows the user to swipe away the notification.
/// - **Decoration**: Provides the visual styling (background, border, shadow).
/// - **Content**: Displays the actual error message and icon.
///
/// A long press on the notification copies the failure details to the clipboard.
///
/// Sub-components:
/// - [_FadeWrapper]: Handles the fade-in and fade-out animations.
/// - [_Dismissible]: Manages the swipe-to-dismiss functionality.
/// - [_Decoration]: Defines the visual appearance of the notification container.
/// - [_Content]: Renders the icon and text of the failure message.
/// {@endtemplate}
class InAppNotificationWidget extends StatelessWidget {
  /// {@macro in_app_notification}
  const InAppNotificationWidget({required this.notification, super.key});

  /// The [Failure] object containing the error information to display.
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
