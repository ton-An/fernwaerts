import 'package:equatable/equatable.dart';
import 'package:webfabrik_theme/webfabrik_theme.dart';

/// {@template account_settings_state}
/// Base state for account settings actions.
/// {@endtemplate}
abstract class AccountSettingsState extends Equatable {
  /// {@macro account_settings_state}
  const AccountSettingsState();

  @override
  List<Object> get props => [];
}

/// {@template account_settings_initial}
/// No account settings action is currently running.
/// {@endtemplate}
class AccountSettingsInitial extends AccountSettingsState {
  /// {@macro account_settings_initial}
  const AccountSettingsInitial();
}

/// {@template sending_verification_email}
/// An email update verification request is in progress.
/// {@endtemplate}
class SendingVerificationEmail extends AccountSettingsState {
  /// {@macro sending_verification_email}
  const SendingVerificationEmail();
}

/// {@template verification_email_sent}
/// The email update verification request completed successfully.
/// {@endtemplate}
class VerificationEmailSent extends AccountSettingsState {
  /// {@macro verification_email_sent}
  const VerificationEmailSent();
}

/// {@template account_settings_failure}
/// An account settings action failed.
/// {@endtemplate}
class AccountSettingsFailure extends AccountSettingsState {
  /// {@macro account_settings_failure}
  const AccountSettingsFailure({required this.failure});

  /// Failure returned by the account settings use case.
  final Failure failure;

  @override
  List<Object> get props => [failure];
}
