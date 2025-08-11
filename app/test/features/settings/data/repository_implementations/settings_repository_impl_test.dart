import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/authentication/email_address_invalid_failure.dart';
import 'package:location_history/core/failures/authentication/email_address_taken_failure.dart';
import 'package:location_history/core/failures/authentication/email_rate_limit_failure.dart';
import 'package:location_history/core/failures/authentication/email_server_config_failure.dart';
import 'package:location_history/core/failures/networking/send_timeout_failure.dart';
import 'package:location_history/core/failures/networking/server_type.dart';
import 'package:location_history/features/settings/data/repository_implementations/settings_repository_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../fixtures.dart';
import '../../../../mocks/mocks.dart';

void main() {
  late SettingsRepositoryImpl settingsRepositoryImpl;
  late MockSettingsRemoteDataSource mockSettingsRemoteDataSource;
  late MockRepositoryFailureHandler mockRepositoryFailureHandler;

  setUp(() {
    mockSettingsRemoteDataSource = MockSettingsRemoteDataSource();
    mockRepositoryFailureHandler = MockRepositoryFailureHandler();
    settingsRepositoryImpl = SettingsRepositoryImpl(
      settingsRemoteDataSource: mockSettingsRemoteDataSource,
      repositoryFailureHandler: mockRepositoryFailureHandler,
    );
  });

  setUpAll(() {
    registerFallbackValue(tTimeoutClientException);
    registerFallbackValue(tStackTrace);
    registerFallbackValue(ServerType.supabase);
  });

  group('updateEmail', () {
    setUp(() {
      when(
        () => mockSettingsRemoteDataSource.updateEmail(
          newEmail: any(named: 'newEmail'),
        ),
      ).thenAnswer((_) => Future.value());
    });

    test('should update the email and return none', () async {
      // act
      final result = await settingsRepositoryImpl.updateEmail(newEmail: tEmail);

      // assert
      expect(result, const Right(None()));
      verify(() => mockSettingsRemoteDataSource.updateEmail(newEmail: tEmail));
    });

    test(
      'should return a failure if the email server config is invalid',
      () async {
        // arrange
        when(
          () => mockSettingsRemoteDataSource.updateEmail(
            newEmail: any(named: 'newEmail'),
          ),
        ).thenThrow(AuthApiException('Error sending email change email'));

        // act
        final result = await settingsRepositoryImpl.updateEmail(
          newEmail: tEmail,
        );

        // assert
        expect(result, const Left(EmailServerConfigFailure()));
      },
    );

    test('should return a failure if the email is invalid', () async {
      // arrange
      when(
        () => mockSettingsRemoteDataSource.updateEmail(
          newEmail: any(named: 'newEmail'),
        ),
      ).thenThrow(AuthApiException('', code: 'validation_failed'));

      // act
      final result = await settingsRepositoryImpl.updateEmail(newEmail: tEmail);

      // assert
      expect(result, const Left(EmailAddressInvalidFailure()));
    });

    test('should return a failure if the email is already in use', () async {
      // arrange
      when(
        () => mockSettingsRemoteDataSource.updateEmail(
          newEmail: any(named: 'newEmail'),
        ),
      ).thenThrow(AuthApiException('', code: 'email_exists'));

      // act
      final result = await settingsRepositoryImpl.updateEmail(newEmail: tEmail);

      // assert
      expect(result, const Left(EmailAddressTakenFailure()));
    });

    test(
      'should return a failure if the email rate limit is exceeded',
      () async {
        // arrange
        when(
          () => mockSettingsRemoteDataSource.updateEmail(
            newEmail: any(named: 'newEmail'),
          ),
        ).thenThrow(AuthApiException('', code: 'over_email_send_rate_limit'));

        // act
        final result = await settingsRepositoryImpl.updateEmail(
          newEmail: tEmail,
        );

        // assert
        expect(result, const Left(EmailRateLimitFailure()));
      },
    );

    test('should convert client exceptions to failures', () async {
      // arrange
      when(
        () => mockSettingsRemoteDataSource.updateEmail(
          newEmail: any(named: 'newEmail'),
        ),
      ).thenThrow(tTimeoutClientException);
      when(
        () => mockRepositoryFailureHandler.clientExceptionConverter(
          clientException: any(named: 'clientException'),
          stackTrace: any(named: 'stackTrace'),
          serverType: any(named: 'serverType'),
        ),
      ).thenReturn(SendTimeoutFailure(serverType: ServerType.supabase));

      // act
      final result = await settingsRepositoryImpl.updateEmail(newEmail: tEmail);

      // assert
      expect(result, Left(SendTimeoutFailure(serverType: ServerType.supabase)));
      verify(
        () => mockRepositoryFailureHandler.clientExceptionConverter(
          clientException: tTimeoutClientException,
          stackTrace: any(named: 'stackTrace'),
          serverType: ServerType.supabase,
        ),
      );
    });
  });
}
