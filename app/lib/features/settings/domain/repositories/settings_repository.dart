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

abstract class SettingsRepository {
  /// Updates the email address of the current user.
  ///
  /// Parameters:
  /// - [String]: new email address to update to
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
  /// - [String]: new password to update to
  /// - [String]: OTP code (if required)
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
  /// Failures:
  /// - [EmailRateLimitFailure]
  /// {@macro converted_client_exceptions}
  Future<Either<Failure, None>> requestOtp();
}
