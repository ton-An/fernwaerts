import 'package:equatable/equatable.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

/// {@template invite_new_user_state}
/// Base state for invite-new-user actions.
/// {@endtemplate}
abstract class InviteNewUserState extends Equatable {
  /// {@macro invite_new_user_state}
  const InviteNewUserState();

  @override
  List<Object?> get props => [];
}

/// {@template invite_new_user_initial}
/// No invite request is currently running.
/// {@endtemplate}
class InviteNewUserInitial extends InviteNewUserState {
  /// {@macro invite_new_user_initial}
  const InviteNewUserInitial();
}

/// {@template invite_new_user_loading}
/// An invite request is in progress.
/// {@endtemplate}
class InviteNewUserLoading extends InviteNewUserState {
  /// {@macro invite_new_user_loading}
  const InviteNewUserLoading();
}

/// {@template invite_new_user_success}
/// The invite request completed successfully.
/// {@endtemplate}
class InviteNewUserSuccess extends InviteNewUserState {
  /// {@macro invite_new_user_success}
  const InviteNewUserSuccess();
}

/// {@template invite_new_user_failure}
/// The invite request failed.
/// {@endtemplate}
class InviteNewUserFailure extends InviteNewUserState {
  /// {@macro invite_new_user_failure}
  const InviteNewUserFailure({required this.failure});

  /// Failure returned by the invite use case.
  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
