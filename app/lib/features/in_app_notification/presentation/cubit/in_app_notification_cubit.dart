import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/in_app_notification/presentation/cubit/in_app_notification_states.dart';

/// __In App Notification Cubit__ controls the state in app notifications throughout the app and
/// works in conjunction with [InAppNotificationListener] to apply the notification overlay
class InAppNotificationCubit extends Cubit<InAppNotificationState> {
  InAppNotificationCubit() : super(const InAppNotificationInitial());

  Failure? failure;
  OverlayEntry? overlayEntry;

  /// Sends a notification displaying a [Failure]
  ///
  /// Parameters:
  /// - [Failure]: the new failure to be displayed
  void sendFailureNotification(Failure failure) {
    if (this.failure == null) {
      emit(InAppNotificationInitiating(failure: failure));
    } else {
      emit(const InAppNotificationReplacing());
    }
    this.failure = failure;
  }

  /// Confirms that the current in app notification has been replaced
  void confirmNotificationReplaced() {
    overlayEntry?.remove();
    emit(InAppNotificationInitiating(failure: failure!));
  }

  /// Confirms that the current in app notification has been delivered
  void confirmNotificationDelivered() {
    emit(const InAppNotificationDelivered());
  }

  /// Delivers a new notification and sets the current [overlayEntry]
  ///
  /// Properties:
  /// - [OverlayEntry]: the overlay entry of the notification
  void deliverNotification({required OverlayEntry overlayEntry}) {
    this.overlayEntry = overlayEntry;
    emit(InAppNotificationDelivering(overlayEntry: overlayEntry));
  }

  /// Dismisses the current in app notification
  void dismissNotification() {
    emit(const InAppNotificationDismissed());
    overlayEntry!.remove();
    failure = null;
    overlayEntry = null;
  }
}
