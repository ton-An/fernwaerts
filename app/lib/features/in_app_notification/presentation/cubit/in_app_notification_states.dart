import 'package:flutter/cupertino.dart';
import 'package:location_history/core/failures/failure.dart';

abstract class InAppNotificationState {
  const InAppNotificationState();
}

/// {@template in_app_notification_initial}
/// A class that represents in app notification initial.
/// {@endtemplate}
class InAppNotificationInitial extends InAppNotificationState {
/// {@macro in_app_notification_initial}
  const InAppNotificationInitial();
}

/// {@template in_app_notification_initiating}
/// A class that represents in app notification initiating.
/// {@endtemplate}
class InAppNotificationInitiating extends InAppNotificationState {
/// {@macro in_app_notification_initiating}
  const InAppNotificationInitiating({required this.failure});

  final Failure failure;
}

/// {@template in_app_notification_delivering}
/// A class that represents in app notification delivering.
/// {@endtemplate}
class InAppNotificationDelivering extends InAppNotificationState {
/// {@macro in_app_notification_delivering}
  const InAppNotificationDelivering({required this.overlayEntry});

  final OverlayEntry overlayEntry;
}

/// {@template in_app_notification_delivered}
/// A class that represents in app notification delivered.
/// {@endtemplate}
class InAppNotificationDelivered extends InAppNotificationState {
/// {@macro in_app_notification_delivered}
  const InAppNotificationDelivered();
}

/// {@template in_app_notification_replacing}
/// A class that represents in app notification replacing.
/// {@endtemplate}
class InAppNotificationReplacing extends InAppNotificationState {
/// {@macro in_app_notification_replacing}
  const InAppNotificationReplacing();
}

/// {@template in_app_notification_dismissed}
/// A class that represents in app notification dismissed.
/// {@endtemplate}
class InAppNotificationDismissed extends InAppNotificationState {
/// {@macro in_app_notification_dismissed}
  const InAppNotificationDismissed();
}
