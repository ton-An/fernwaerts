import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/in_app_notification/presentation/cubit/in_app_notification_cubit.dart';
import 'package:location_history/features/in_app_notification/presentation/cubit/in_app_notification_states.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

part '_content.dart';
part '_decoration.dart';
part '_dismissible.dart';
part '_fade_wrapper.dart';

/*
  To-Dos:
  - [ ] Implement this screen and clean up
  - [ ] Clear up naming of the whole in app notification feature
  - [ ] Add a toast like notification when the failure has been copied to clipboard
*/

/// __In App Notification__ builds an in app notification wich displays a [Failure]
class InAppNotification extends StatelessWidget {
  const InAppNotification({required this.failure, super.key});

  final Failure failure;

  @override
  Widget build(BuildContext context) {
    final WebfabrikThemeData theme = WebfabrikTheme.of(context);

    return GestureDetector(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: failure.toString()));
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
              movementDuration: const Duration(milliseconds: 450),
              reverseMovementDuration: const Duration(milliseconds: 2000),
              entryDuration: const Duration(milliseconds: 800),
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
                      child: _Content(failure: failure),
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
