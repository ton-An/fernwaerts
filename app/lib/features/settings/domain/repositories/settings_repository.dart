import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/authentication/email_address_invalid_failure.dart';
import 'package:location_history/core/failures/authentication/email_address_taken_failure.dart';
import 'package:location_history/core/failures/authentication/email_rate_limit_failure.dart';
import 'package:location_history/core/failures/authentication/email_server_config_failure.dart';
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
}
