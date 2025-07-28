import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/features/in_app_notification/presentation/cubit/in_app_notification_states.dart';

/*
  To-Do:
    - [ ] Add tests
*/

/// {@template in_app_notification_cubit}
/// Controls the state in app notifications throughout the app and
/// works in conjunction with [InAppNotificationListener] to apply the notification overlay
/// to the app.
/// {@endtemplate}
class InAppNotificationCubit extends Cubit<InAppNotificationState> {
  /// {@macro in_app_notification_cubit}
  InAppNotificationCubit() : super(const InAppNotificationInitial());

  Failure? failure;
  OverlayEntry? overlayEntry;

  /// Sends a notification displaying a [Failure]
  ///
  /// Parameters:
  /// - [Failure]: the new failure to be displayed
  ///
  /// Emits:
  /// - [InAppNotificationInitiating] if it is the first failure
  /// - [InAppNotificationReplacing] on subsequent failures
  void sendFailureNotification(Failure failure) {
    if (this.failure == null) {
      emit(InAppNotificationInitiating(failure: failure));
    } else {
      emit(const InAppNotificationReplacing());
    }
    this.failure = failure;
  }

  /// Confirms that the current in app notification has been replaced
  /// and updates the notification with the new failure
  ///
  /// Emits:
  /// - [InAppNotificationInitiating] with the new failure
  void confirmNotificationReplaced() {
    overlayEntry?.remove();
    emit(InAppNotificationInitiating(failure: failure!));
  }

  /// Confirms that the current in app notification has been delivered
  ///
  /// Emits:
  /// - [InAppNotificationDelivered]
  void confirmNotificationDelivered() {
    emit(const InAppNotificationDelivered());
  }

  /// Delivers a new notification and sets the current [overlayEntry]
  ///
  /// Properties:
  /// - [OverlayEntry]: the overlay entry of the notification
  ///
  /// Emits:
  /// - [InAppNotificationDelivering] with the new overlay entry
  void deliverNotification({required OverlayEntry overlayEntry}) {
    this.overlayEntry = overlayEntry;
    emit(InAppNotificationDelivering(overlayEntry: overlayEntry));
  }

  /// Dismisses the current in app notification
  ///
  /// Emits:
  /// - [InAppNotificationDismissed]
  void dismissNotification() {
    emit(const InAppNotificationDismissed());
    overlayEntry!.remove();
    failure = null;
    overlayEntry = null;
  }
}
