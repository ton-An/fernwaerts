import 'package:location_history/core/failures/failure.dart';

/// {@template invite_cubit_state}
/// Base state for accepting a user invite from a deep link.
/// {@endtemplate}
abstract class InviteCubitState {
  /// {@macro invite_cubit_state}
  const InviteCubitState();
}

/// {@template invite_initial_state}
/// Initial invite flow state before the user submits invite credentials.
/// {@endtemplate}
class InviteInitialState extends InviteCubitState {
  /// {@macro invite_initial_state}
  const InviteInitialState();
}

/// {@template invite_loading}
/// Indicates that invite acceptance is currently running.
/// {@endtemplate}
class InviteLoading extends InviteCubitState {
  /// {@macro invite_loading}
  const InviteLoading();
}

/// {@template invite_successful}
/// Indicates that the invite was accepted and the app can enter the map.
/// {@endtemplate}
class InviteSuccessful extends InviteCubitState {
  /// {@macro invite_successful}
  const InviteSuccessful();
}

/// {@template invite_failure}
/// Carries a recoverable [failure] from invite acceptance or setup.
/// {@endtemplate}
class InviteFailure extends InviteCubitState {
  /// {@macro invite_failure}
  const InviteFailure({required this.failure});

  /// Failure displayed to the user by the invite page listener.
  final Failure failure;
}
