import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/authentication/email_address_invalid_failure.dart';
import 'package:location_history/core/failures/authentication/email_address_taken_failure.dart';
import 'package:location_history/core/failures/authentication/email_rate_limit_failure.dart';
import 'package:location_history/core/failures/authentication/email_server_config_failure.dart';
import 'package:location_history/core/failures/authentication/need_otp_reauthentication_failure.dart';
import 'package:location_history/core/failures/authentication/otp_invalid_failure.dart';
import 'package:location_history/core/failures/authentication/passwords_must_differ.dart';
import 'package:location_history/core/failures/authentication/weak_password_failure.dart';
import 'package:location_history/core/failures/failure.dart';

/// {@template settings_repository}
/// Domain contract for account-management actions available from settings.
///
/// Callers should use this contract for updating the current user's account
/// credentials, requesting password reauthentication, and inviting new users.
/// {@endtemplate}
abstract class SettingsRepository {
  /// {@macro settings_repository}
  const SettingsRepository();

  /// Updates the email address of the current user.
  ///
  /// Parameters:
  /// - newEmail: [String] new email address to update to
  ///
  /// Failures:
  /// - [EmailServerConfigFailure]
  /// - [EmailAddressInvalidFailure]
  /// - [EmailAddressTakenFailure]
  /// - [EmailRateLimitFailure]
  /// {@macro converted_client_exceptions}
  Future<Either<Failure, None>> updateEmail({required String newEmail});

  /// Updates the password of the current user.
  ///
  /// Parameters:
  /// - newPassword: [String] new password to update to
  /// - otp: [String?] one-time password used when reauthentication is required
  ///
  /// Failures:
  /// - [WeakPasswordFailure]
  /// - [NeedOtpReauthenticationFailure]
  /// - [PasswordMustDifferFailure]
  /// - [OtpInvalidFailure]
  /// {@macro converted_client_exceptions}

  Future<Either<Failure, None>> updatePassword({
    required String newPassword,
    String? otp,
  });

  /// Requests an OTP to reauthenticate the user.
  ///
  /// The OTP is sent through the current user's configured email channel.
  ///
  /// Failures:
  /// - [EmailRateLimitFailure]
  /// {@macro converted_client_exceptions}
  Future<Either<Failure, None>> requestOtp();

  /// Invites a new user to the application.
  ///
  /// Parameters:
  /// - email: [String] email address of the user to invite
  ///
  /// Failures:
  /// - [EmailServerConfigFailure]
  /// - [EmailAddressInvalidFailure]
  /// - [EmailAddressTakenFailure]
  /// - [EmailRateLimitFailure]
  /// {@macro converted_client_exceptions}
  Future<Either<Failure, None>> inviteNewUser({required String email});
}
