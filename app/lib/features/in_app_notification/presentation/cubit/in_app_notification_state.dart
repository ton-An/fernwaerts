import 'package:flutter/cupertino.dart';
import 'package:location_history/features/in_app_notification/presentation/cubit/in_app_notification.dart';

/// {@template in_app_notification_state}
/// Base state for the in-app notification overlay lifecycle.
/// {@endtemplate}
abstract class InAppNotificationState {
  /// {@macro in_app_notification_state}
  const InAppNotificationState();
}

/// {@template in_app_notification_initial}
/// No in-app notification has been requested yet.
/// {@endtemplate}
class InAppNotificationInitial extends InAppNotificationState {
  /// {@macro in_app_notification_initial}
  const InAppNotificationInitial();
}

/// {@template in_app_notification_initiating}
/// A notification has been requested and needs an [OverlayEntry].
/// {@endtemplate}
class InAppNotificationInitiating extends InAppNotificationState {
  /// {@macro in_app_notification_initiating}
  const InAppNotificationInitiating({required this.notification});

  /// Notification content to render in the overlay entry.
  final InAppNotification notification;
}

/// {@template in_app_notification_delivering}
/// An [OverlayEntry] has been built and is ready to insert into the [Overlay].
/// {@endtemplate}
class InAppNotificationDelivering extends InAppNotificationState {
  /// {@macro in_app_notification_delivering}
  const InAppNotificationDelivering({required this.overlayEntry});

  /// Overlay entry containing the notification widget.
  final OverlayEntry overlayEntry;
}

/// {@template in_app_notification_delivered}
/// The notification entry animation has completed.
/// {@endtemplate}
class InAppNotificationDelivered extends InAppNotificationState {
  /// {@macro in_app_notification_delivered}
  const InAppNotificationDelivered();
}

/// {@template in_app_notification_replacing}
/// The current notification should animate out before the next one is shown.
/// {@endtemplate}
class InAppNotificationReplacing extends InAppNotificationState {
  /// {@macro in_app_notification_replacing}
  const InAppNotificationReplacing();
}

/// {@template in_app_notification_dismissed}
/// The current notification was dismissed and removed from the overlay.
/// {@endtemplate}
class InAppNotificationDismissed extends InAppNotificationState {
  /// {@macro in_app_notification_dismissed}
  const InAppNotificationDismissed();
}
