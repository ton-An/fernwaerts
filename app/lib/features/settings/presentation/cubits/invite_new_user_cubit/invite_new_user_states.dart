import 'package:equatable/equatable.dart';
import 'package:location_history/core/failures/failure.dart';

abstract class InviteNewUserState extends Equatable {
  const InviteNewUserState();

  @override
  List<Object?> get props => [];
}

class InviteNewUserInitial extends InviteNewUserState {
  const InviteNewUserInitial();
}

class InviteNewUserLoading extends InviteNewUserState {
  const InviteNewUserLoading();
}

class InviteNewUserSuccess extends InviteNewUserState {
  const InviteNewUserSuccess();
}

class InviteNewUserFailure extends InviteNewUserState {
  const InviteNewUserFailure({required this.failure});

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
