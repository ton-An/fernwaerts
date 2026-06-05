import 'package:webfabrik_theme/webfabrik_theme.dart';

/// {@template invite_state}
/// Base state for accepting a user invite from a deep link.
/// {@endtemplate}
abstract class InviteState {
  /// {@macro invite_state}
  const InviteState();
}

/// {@template invite_initial}
/// Initial invite flow state before the user submits invite credentials.
/// {@endtemplate}
class InviteInitial extends InviteState {
  /// {@macro invite_initial}
  const InviteInitial();
}

/// {@template invite_loading}
/// Indicates that invite acceptance is currently running.
/// {@endtemplate}
class InviteLoading extends InviteState {
  /// {@macro invite_loading}
  const InviteLoading();
}

/// {@template invite_success}
/// Reserved for the invite-completion flow once acceptance is implemented.
/// {@endtemplate}
class InviteSuccess extends InviteState {
  /// {@macro invite_success}
  const InviteSuccess();
}

/// {@template invite_failure}
/// Carries a recoverable [failure] from invite acceptance or setup.
/// {@endtemplate}
class InviteFailure extends InviteState {
  /// {@macro invite_failure}
  const InviteFailure({required this.failure});

  /// Failure displayed to the user by the invite page listener.
  final Failure failure;
}
