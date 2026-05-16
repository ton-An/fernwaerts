import 'package:location_history/core/failures/failure.dart';

/// {@template in_app_notification_model}
/// Base model for notification content shown by the in-app notification overlay.
/// {@endtemplate}
sealed class InAppNotification {
  /// {@macro in_app_notification_model}
  const InAppNotification();
}

/// {@template in_app_failure_notification}
/// Notification content for displaying a [Failure].
/// {@endtemplate}
class InAppFailureNotification extends InAppNotification {
  /// {@macro in_app_failure_notification}
  InAppFailureNotification({required this.failure});

  /// Failure whose name and message are shown to the user.
  final Failure failure;
}

/// {@template in_app_success_notification}
/// Notification content for displaying a success title and message.
/// {@endtemplate}
class InAppSuccessNotification extends InAppNotification {
  /// {@macro in_app_success_notification}
  InAppSuccessNotification({required this.title, required this.message});

  /// Title shown in the notification.
  final String title;

  /// Message shown below [title].
  final String message;
}
