import 'package:equatable/equatable.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

/// {@template password_change_state}
/// Base state for password change actions.
/// {@endtemplate}
abstract class PasswordChangeState extends Equatable {
  /// {@macro password_change_state}
  const PasswordChangeState();

  @override
  List<Object?> get props => [];
}

/// {@template password_change_initial}
/// No password change request is currently running.
/// {@endtemplate}
class PasswordChangeInitial extends PasswordChangeState {
  /// {@macro password_change_initial}
  const PasswordChangeInitial();
}

/// {@template password_change_loading}
/// A password change request is in progress.
/// {@endtemplate}
class PasswordChangeLoading extends PasswordChangeState {
  /// {@macro password_change_loading}
  const PasswordChangeLoading();
}

/// {@template password_change_success}
/// The password change request completed successfully.
/// {@endtemplate}
class PasswordChangeSuccess extends PasswordChangeState {
  /// {@macro password_change_success}
  const PasswordChangeSuccess();
}

/// {@template password_change_failure}
/// The password change request failed.
/// {@endtemplate}
class PasswordChangeFailure extends PasswordChangeState {
  /// {@macro password_change_failure}
  const PasswordChangeFailure({required this.failure});

  /// Failure returned by the password change use case.
  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
