import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/features/in_app_notification/presentation/cubit/in_app_notification_cubit.dart';
import 'package:location_history/features/in_app_notification/presentation/cubit/in_app_notification_states.dart';
import 'package:location_history/features/in_app_notification/presentation/widgets/in_app_notification/in_app_notification_widget.dart';

/// {@template in_app_notification_listener}
/// A widget that listens to [InAppNotificationCubit] states and displays
/// in-app notifications accordingly.
///
/// This widget wraps its [child] and uses a [BlocListener] to observe
/// [InAppNotificationState] changes. When an [InAppNotificationInitiating]
/// state is emitted, it creates an [OverlayEntry] with an [InAppNotificationWidget]
/// widget and triggers the cubit to deliver it. When an
/// [InAppNotificationDelivering] state is emitted, it inserts the notification
/// into the [Overlay].
/// {@endtemplate}
class InAppNotificationListener extends StatelessWidget {
  /// {@macro in_app_notification_listener}
  const InAppNotificationListener({super.key, required this.child});

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<InAppNotificationCubit, InAppNotificationState>(
      listener: (context, state) {
        if (state is InAppNotificationInitiating) {
          final OverlayEntry overlayEntry = OverlayEntry(
            builder: (context) {
              return InAppNotificationWidget(notification: state.notification);
            },
          );
          context.read<InAppNotificationCubit>().deliverNotification(
            overlayEntry: overlayEntry,
          );
        }

        if (state is InAppNotificationDelivering) {
          Overlay.of(context).insert(state.overlayEntry);
        }
      },
      child: child,
    );
  }
}
