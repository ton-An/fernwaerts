import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';
import 'package:location_history/core/data/repository/repository_failure_handler.dart';
import 'package:location_history/core/failures/authentication/email_address_invalid_failure.dart';
import 'package:location_history/core/failures/authentication/email_address_taken_failure.dart';
import 'package:location_history/core/failures/authentication/email_rate_limit_failure.dart';
import 'package:location_history/core/failures/authentication/email_server_config_failure.dart';
import 'package:location_history/core/failures/authentication/need_otp_reauthentication_failure.dart';
import 'package:location_history/core/failures/authentication/otp_invalid_failure.dart';
import 'package:location_history/core/failures/authentication/passwords_must_differ.dart';
import 'package:location_history/core/failures/authentication/weak_password_failure.dart';
import 'package:location_history/core/failures/failure.dart';
import 'package:location_history/core/failures/networking/server_type.dart';
import 'package:location_history/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:location_history/features/settings/domain/repositories/settings_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsRepositoryImpl extends SettingsRepository {
  SettingsRepositoryImpl({
    required this.settingsRemoteDataSource,
    required this.repositoryFailureHandler,
  });

  final SettingsRemoteDataSource settingsRemoteDataSource;
  final RepositoryFailureHandler repositoryFailureHandler;

  @override
  Future<Either<Failure, None>> updateEmail({required String newEmail}) async {
    try {
      await settingsRemoteDataSource.updateEmail(newEmail: newEmail);

      return const Right(None());
    } on AuthException catch (authException) {
      if (authException.message.contains('Error sending email change email')) {
        return const Left(EmailServerConfigFailure());
      }

      if (authException.code == 'validation_failed') {
        return const Left(EmailAddressInvalidFailure());
      }

      if (authException.code == 'email_exists') {
        return const Left(EmailAddressTakenFailure());
      }

      if (authException.code == 'over_email_send_rate_limit') {
        return const Left(EmailRateLimitFailure());
      }

      rethrow;
    } on ClientException catch (clientException, stackTrace) {
      final Failure failure = repositoryFailureHandler.clientExceptionConverter(
        clientException: clientException,
        stackTrace: stackTrace,
        serverType: ServerType.supabase,
      );

      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, None>> updatePassword({
    required String newPassword,
    String? otp,
  }) async {
    try {
      await settingsRemoteDataSource.updatePassword(
        newPassword: newPassword,
        otp: otp,
      );

      return const Right(None());
    } on AuthException catch (authException) {
      if (authException is AuthWeakPasswordException) {
        return const Left(WeakPasswordFailure());
      }

      if (authException.code == 'reauthentication_needed') {
        return const Left(NeedOtpReauthenticationFailure());
      }

      if (authException.code == 'same_password') {
        return const Left(PasswordMustDifferFailure());
      }

      if (authException.code == 'reauthentication_not_valid') {
        return const Left(OtpInvalidFailure());
      }

      rethrow;
    } on ClientException catch (clientException, stackTrace) {
      final Failure failure = repositoryFailureHandler.clientExceptionConverter(
        clientException: clientException,
        stackTrace: stackTrace,
        serverType: ServerType.supabase,
      );

      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, None>> requestOtp() async {
    try {
      await settingsRemoteDataSource.requestOtp();

      return const Right(None());
    } on AuthException catch (authException) {
      if (authException.code == 'over_email_send_rate_limit') {
        return const Left(EmailRateLimitFailure());
      }

      rethrow;
    } on ClientException catch (clientException, stackTrace) {
      final Failure failure = repositoryFailureHandler.clientExceptionConverter(
        clientException: clientException,
        stackTrace: stackTrace,
        serverType: ServerType.supabase,
      );

      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, None>> inviteNewUser({required String email}) async {
    try {
      await settingsRemoteDataSource.inviteNewUser(email: email);

      return const Right(None());
    } on FunctionException catch (functionException) {
      final String errorMessage = functionException.details['message'];
      final String errorCode = functionException.details['code'];

      if (errorMessage.contains('Error sending invite email')) {
        return const Left(EmailServerConfigFailure());
      }

      if (errorCode == 'validation_failed') {
        return const Left(EmailAddressInvalidFailure());
      }

      if (errorCode == 'email_exists') {
        return const Left(EmailAddressTakenFailure());
      }

      if (errorCode == 'over_email_send_rate_limit') {
        return const Left(EmailRateLimitFailure());
      }

      rethrow;
    } on ClientException catch (clientException, stackTrace) {
      final Failure failure = repositoryFailureHandler.clientExceptionConverter(
        clientException: clientException,
        stackTrace: stackTrace,
        serverType: ServerType.supabase,
      );

      return Left(failure);
    }
  }
}
