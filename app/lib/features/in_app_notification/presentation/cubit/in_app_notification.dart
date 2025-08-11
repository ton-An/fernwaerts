import 'package:location_history/core/failures/failure.dart';

sealed class InAppNotification {}

class InAppFailureNotification extends InAppNotification {
  InAppFailureNotification({required this.failure});

  final Failure failure;
}

class InAppSuccessNotification extends InAppNotification {
  InAppSuccessNotification({required this.title, required this.message});
  final String title;
  final String message;
}
