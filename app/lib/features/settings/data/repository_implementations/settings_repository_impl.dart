import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';
import 'package:location_history/core/data/repository/repository_failure_handler.dart';
import 'package:location_history/core/failures/authentication/email_address_invalid_failure.dart';
import 'package:location_history/core/failures/authentication/email_address_taken_failure.dart';
import 'package:location_history/core/failures/authentication/email_rate_limit_failure.dart';
import 'package:location_history/core/failures/authentication/email_server_config_failure.dart';
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
}
