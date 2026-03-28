import 'package:location_history/core/failures/failure.dart';

abstract class InviteCubitState {
  const InviteCubitState();
}

class InviteInitialState extends InviteCubitState {
  const InviteInitialState();
}

class InviteLoading extends InviteCubitState {
  const InviteLoading();
}

class InviteSuccessful extends InviteCubitState {
  const InviteSuccessful();
}

class InviteFailure extends InviteCubitState {
  const InviteFailure({required this.failure});

  final Failure failure;
}
