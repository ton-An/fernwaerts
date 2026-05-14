import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/in_app_notification/presentation/cubit/in_app_notification.dart';
import 'package:location_history/features/in_app_notification/presentation/cubit/in_app_notification_states.dart';

/*
  To-Do:
    - [ ] Add tests
*/

/// {@template in_app_notification_cubit}
/// Coordinates the lifecycle of app-wide in-app notification overlays.
///
/// [InAppNotificationListener] reacts to the emitted states by creating,
/// inserting, replacing, and removing the overlay entry.
/// {@endtemplate}
class InAppNotificationCubit extends Cubit<InAppNotificationState> {
  /// {@macro in_app_notification_cubit}
  InAppNotificationCubit() : super(const InAppNotificationInitial());

  /// Notification content currently shown or waiting to be shown.
  InAppNotification? notification;

  /// Overlay entry for the currently shown notification.
  OverlayEntry? overlayEntry;

  /// Sends a notification displaying [failure].
  ///
  /// Parameters:
  /// - [failure]: Failure to display.
  ///
  /// {@template send_notification_states}
  /// Emits:
  /// - [InAppNotificationInitiating] when no notification is currently active.
  /// - [InAppNotificationReplacing] when an active notification must be
  ///   replaced first.
  /// {@endtemplate}
  void sendFailureNotification(Failure failure) {
    final InAppFailureNotification failureNotification =
        InAppFailureNotification(failure: failure);

    _sendNotification(newNotification: failureNotification);
  }

  /// Sends a notification displaying a success [title] and [message].
  ///
  /// Parameters:
  /// - [title]: Title shown in the notification.
  /// - [message]: Message shown below [title].
  ///
  /// Emits:
  /// {@macro send_notification_states}
  void sendSuccessNotification({
    required String title,
    required String message,
  }) {
    final InAppSuccessNotification successNotification =
        InAppSuccessNotification(title: title, message: message);

    _sendNotification(newNotification: successNotification);
  }

  void _sendNotification({required InAppNotification newNotification}) {
    if (notification == null) {
      emit(InAppNotificationInitiating(notification: newNotification));
    } else {
      emit(const InAppNotificationReplacing());
    }

    notification = newNotification;
  }

  /// Confirms that the current in-app notification has animated out.
  ///
  /// Emits:
  /// - [InAppNotificationInitiating] with the pending replacement notification.
  void confirmNotificationReplaced() {
    overlayEntry?.remove();
    emit(InAppNotificationInitiating(notification: notification!));
  }

  /// Confirms that the current in-app notification has finished animating in.
  ///
  /// Emits:
  /// - [InAppNotificationDelivered]
  void confirmNotificationDelivered() {
    emit(const InAppNotificationDelivered());
  }

  /// Stores and delivers a new notification [overlayEntry].
  ///
  /// Parameters:
  /// - [overlayEntry]: Overlay entry containing the notification widget.
  ///
  /// Emits:
  /// - [InAppNotificationDelivering] with [overlayEntry].
  void deliverNotification({required OverlayEntry overlayEntry}) {
    this.overlayEntry = overlayEntry;
    emit(InAppNotificationDelivering(overlayEntry: overlayEntry));
  }

  /// Dismisses the current in-app notification and clears its overlay state.
  ///
  /// Emits:
  /// - [InAppNotificationDismissed]
  void dismissNotification() {
    emit(const InAppNotificationDismissed());
    overlayEntry!.remove();
    notification = null;
    overlayEntry = null;
  }
}
