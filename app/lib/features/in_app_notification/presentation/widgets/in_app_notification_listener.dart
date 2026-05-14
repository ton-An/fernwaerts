import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/features/in_app_notification/presentation/cubit/in_app_notification_cubit.dart';
import 'package:location_history/features/in_app_notification/presentation/cubit/in_app_notification_states.dart';
import 'package:location_history/features/in_app_notification/presentation/widgets/in_app_notification/in_app_notification_widget.dart';

/// {@template in_app_notification_listener}
/// Bridges [InAppNotificationCubit] lifecycle states to Flutter's [Overlay].
///
/// When the Cubit emits [InAppNotificationInitiating], this listener builds an
/// [OverlayEntry] containing [InAppNotificationWidget] and hands it back to the
/// Cubit. When the Cubit emits [InAppNotificationDelivering], the listener
/// inserts that entry into the nearest overlay.
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
