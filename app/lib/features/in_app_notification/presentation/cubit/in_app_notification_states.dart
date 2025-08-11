import 'package:flutter/cupertino.dart';
import 'package:location_history/features/in_app_notification/presentation/cubit/in_app_notification.dart';

abstract class InAppNotificationState {
  const InAppNotificationState();
}

class InAppNotificationInitial extends InAppNotificationState {
  const InAppNotificationInitial();
}

class InAppNotificationInitiating extends InAppNotificationState {
  const InAppNotificationInitiating({required this.notification});

  final InAppNotification notification;
}

class InAppNotificationDelivering extends InAppNotificationState {
  const InAppNotificationDelivering({required this.overlayEntry});

  final OverlayEntry overlayEntry;
}

class InAppNotificationDelivered extends InAppNotificationState {
  const InAppNotificationDelivered();
}

class InAppNotificationReplacing extends InAppNotificationState {
  const InAppNotificationReplacing();
}

class InAppNotificationDismissed extends InAppNotificationState {
  const InAppNotificationDismissed();
}
